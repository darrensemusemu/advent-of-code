const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var alloc = arena.allocator();

    const args = try std.process.argsAlloc(alloc);
    if (args.len != 2) return error.MissingFileArg;

    var file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();

    var res = try parseSrc(alloc, file.reader(), 12, 13, 14);
    try std.io.getStdOut().writer().print("result: {} ", .{res});
}

const Game = struct {
    id: u32,
    R: u32,
    G: u32,
    B: u32,
};

fn parseSrc(alloc: std.mem.Allocator, reader: anytype, r: u32, g: u32, b: u32) !u32 {
    var list = std.ArrayList(Game).init(alloc);
    defer list.deinit();

    var res: u32 = 0;
    var buf: [1028]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);

    while (reader.streamUntilDelimiter(fbs.writer(), '\n', null)) {
        var line = fbs.getWritten();

        var iter = std.mem.tokenizeAny(u8, line, ":");

        var game = iter.next().?;
        var game_num = try std.fmt.parseInt(u8, game["Game ".len..], 10);

        var cubes_line = iter.next();

        var bags_iter = std.mem.tokenizeAny(u8, cubes_line.?, ";");
        var bag = bags_iter.next();

        while (bag != null) : (bag = bags_iter.next()) inner1: {
            var item_iter = std.mem.tokenizeAny(u8, bag.?, " ,");
            var item = item_iter.next();

            while (item != null) : (item = item_iter.next()) {
                var num = try std.fmt.parseInt(u8, item.?, 10);

                var color = item_iter.next().?;

                if (std.mem.eql(u8, color, "red") and r < num) {
                    try std.io.getStdErr().writer().print("nmm-{}<{}\n", .{ num, r });
                    game_num = 0;
                    break :inner1;
                } else if (std.mem.eql(u8, color, "green") and g < num) {
                    try std.io.getStdErr().writer().print("nmm-{}<{}\n", .{ num, r });
                    game_num = 0;
                    break :inner1;
                } else if (std.mem.eql(u8, color, "blue") and b < num) {
                    try std.io.getStdErr().writer().print("nmm-{}<{}\n", .{ num, r });
                    game_num = 0;
                    break :inner1;
                }
            }
        }

        // try std.io.getStdErr().writer().print("\nadded-{}<\n", .{game_num});

        res += game_num;
        defer fbs.reset();
    } else |err| {
        if (err != error.EndOfStream) return err;
    }

    return res;
}

test "test input" {
    var src_contents =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        \\
    ;

    var fbs = std.io.fixedBufferStream(src_contents);

    var res = try parseSrc(std.testing.allocator, fbs.reader(), 12, 13, 14);
    try std.testing.expectEqual(res, 8);
    // var res = parseSrc(src);
}
