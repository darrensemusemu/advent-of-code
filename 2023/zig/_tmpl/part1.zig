const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var alloc = arena.allocator();

    const args = try std.process.argsAlloc(alloc);
    if (args.len != 2) return error.MissingFileArg;

    var file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();

    var res = try parseSrc(alloc, file.reader());
    try std.io.getStdOut().writer().print("result: {} ", .{res});
}

const Args = struct {
    //
};

fn parseSrc(alloc: std.mem.Allocator, reader: anytype) !u32 {
    _ = alloc;

    var res: u32 = 0;

    var buf: [1028]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);

    while (reader.streamUntilDelimiter(fbs.writer(), '\n', null)) {
        var line = fbs.getWritten();
        defer fbs.reset();

        _ = line;

        // try std.io.getStdErr().writer().print("added-{}<\n", .{(stats.r * stats.g * stats.b)});
    } else |err| {
        if (err != error.EndOfStream) return err;
    }

    return res;
}

test "test input" {
    var src_contents =
        \\
    ;

    var fbs = std.io.fixedBufferStream(src_contents);

    var res = try parseSrc(std.testing.allocator, fbs.reader(), Args{});
    try std.testing.expectEqual(res, 8);
}
