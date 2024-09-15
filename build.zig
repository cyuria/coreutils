const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const cat = b.addExecutable(.{
        .name = "cat",
        .root_source_file = b.path("src/cat.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(cat);

    const cat_run_cmd = b.addRunArtifact(cat);

    cat_run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        cat_run_cmd.addArgs(args);
    }

    const cat_run_step = b.step("cat", "Execute cat");
    cat_run_step.dependOn(&cat_run_cmd.step);

    const cat_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/cat.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_cat_unit_tests = b.addRunArtifact(cat_unit_tests);

    const test_step = b.step("test_cat", "Run unit tests for cat");
    test_step.dependOn(&run_cat_unit_tests.step);
}
