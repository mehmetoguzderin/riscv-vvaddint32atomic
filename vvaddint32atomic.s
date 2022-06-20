.global vvaddint32atomic
.type vvaddint32atomic, @function
vvaddint32atomic: # void(int n, const int* x, const int* y, int* z, int* i)
fence rw, rw
lw t0, (a4)
fence r, rw
bge t0, a0, .vvaddint32atomic_return
sub t1, a0, t0
vsetvli t2, t1, e32, m1, ta, ma
amoadd.w.aqrl t0, t2, (a4)
bge t0, a0, .vvaddint32atomic_return
add t2, t2, t0
slli t0, t0, 2
add t3, a1, t0
add t4, a2, t0
add t5, a3, t0
vle32.v v0, (t3)
vle32.v v1, (t4)
vadd.vv v2, v0, v1
vse32.v v2, (t5)
blt t2, a0, vvaddint32atomic
.vvaddint32atomic_return:
ret