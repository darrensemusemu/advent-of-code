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
    var buf: [2048]u8 = undefined;
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
    var lookup_start_index: usize = 0;

    for (line, 0..) |f, i| {
        switch (f) {
            '0'...'9' => {
                res = .{ res[0] orelse f, f };
                lookup_start_index += 1;
            },
            else => {
                var sliding_buf = line[lookup_start_index .. i + 1];

                for (word_lookup.kvs) |kvs| inner: {
                    var idx = std.mem.indexOf(u8, sliding_buf, kvs.key) orelse continue;
                    lookup_start_index += idx;
                    lookup_start_index += 1;
                    res = .{ res[0] orelse kvs.value, kvs.value };
                    break :inner;
                }
            },
        }
    }

    return try std.fmt.parseInt(u32, &.{ res[0].?, res[1].? }, 10);
}

const word_lookup = std.ComptimeStringMap(u8, .{
    .{ "one", '1' },
    .{ "two", '2' },
    .{ "three", '3' },
    .{ "four", '4' },
    .{ "five", '5' },
    .{ "six", '6' },
    .{ "seven", '7' },
    .{ "eight", '8' },
    .{ "nine", '9' },
});

test "part1 calibrateLine" {
    var src: []const u8 = "two1nine";
    try std.testing.expectEqual(calibrateLine(src), 29);

    src = "eightwothree";
    try std.testing.expectEqual(calibrateLine(src), 83);

    src = "abcone2threexyz";
    try std.testing.expectEqual(calibrateLine(src), 13);

    src = "oneight";
    try std.testing.expectEqual(calibrateLine(src), 18);

    src = "oneightwo";
    try std.testing.expectEqual(calibrateLine(src), 12);

    src = "fbfvqgvqfone5nctdcdpteighttwo";
    try std.testing.expectEqual(calibrateLine(src), 12);
}
