
`strace` is a userspace diagnostic utility for Linux. `strace` relies on system call `ptrace()`.

`dtrace` is a modern cross-platform utility. `dtrace` 

`bpftrace` is `dtrace`-stype diagnostic utility extending to Linux kernel for eBPF.

`truss` is for Unix-like.
`dtruss` is a `dtrace` version of truss, designed to be less of a burden and safer than truss. 

# Tools

src: https://www.brendangregg.com/dtrace.html

src: https://www.quora.com/What-is-the-difference-between-DTrace-and-STrace

src: https://dev.to/captainsafia/say-this-five-times-fast-strace-ptrace-dtrace-dtruss-3e1b

**Strace** is a system call tracer; it shows you the calls that processes make as well as their arguments and return values. It’s a stand-alone command that makes use of the operating system’s debugging interface called ptrace.

**DTrace** allows for nearly arbitrary instrumentation of the system. It’s a kernel facility that was originally written for Solaris (then of Sun, now of Oracle), and later open sourced, and ported to macOS, FreeBSD, and others. DTrace publishes points of instrumentation throughout the system, from kernel facilities such as IO and scheduling to user-level function calls in C, Java, JavaScript, etc, and—overlapping with Strace—system calls. Users enable DTrace probes and specify the actions to be executed when the probe is hit using a purpose-built language called “D”.


Whereas **strace** relies on **ptrace** to introspect processes, dtrace goes about things a little bit differently. With **dtrace**, the programmer writes probes in a language with a C-like syntax called D. These probes define what dtrace should do when it invokes a system call, exits a function, or whatever else you'd like. These probes are stored in a script file that looks something like this.

The first definition I ran into was from the **dtruss** manpage which defined dtruss as a "a DTrace version of truss." Well, I guess I better figure out what truss is first then. As it turns out, truss is a Unix-specific command that allows the user to print out the system calls made by a program. It's essentally a varient of the strace tool that exists on Linux. Knowing this, I think the best way to describe it would be to use an analogy: strace is to dtrace as truss is to dtruss.


https://en.wikipedia.org/wiki/Ktrace
Since Mac OS X Leopard, ktrace has been replaced by DTrace.