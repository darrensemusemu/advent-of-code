const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var alloc = arena.allocator();

    const args = try std.process.argsAlloc(alloc);
    if (args.len != 2) return error.MissingFileArg;

    var res = try calibrateSrc(args[1]);
    try std.io.getStdOut().writer().print("result: {} ", .{res});
}

fn calibrateSrc(src: []const u8) !u32 {
    var file = try std.fs.cwd().openFile(src, .{});
    var reader = file.reader();

    var calib_val: u32 = 0;
    var buf: [1028]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);

    while (reader.streamUntilDelimiter(fbs.writer(), '\n', null)) {
        calib_val += try calibrateLine(fbs.getWritten());

        fbs.reset();
    } else |err| {
        if (err != error.EndOfStream) return err;
    }

    return calib_val;
}

fn calibrateLine(line: []const u8) !u32 {
    var res: [2]?u8 = .{null} ** 2;

    for (line) |f| {
        switch (f) {
            '0'...'9' => res = .{ res[0] orelse f, f },
            else => continue,
        }
    }

    return try std.fmt.parseInt(u32, &.{ res[0].?, res[1].? }, 10);
}

test "part1 calibrateLine" {
    var src: []const u8 = "1abc2";
    try std.testing.expectEqual(calibrateLine(src), 12);

    src = "treb7uchet";
    try std.testing.expectEqual(calibrateLine(src), 77);
}
