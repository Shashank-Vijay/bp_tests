
include Makefile.frag

RISCV_GCC  = $(CROSS_COMPILE)gcc --static -nostartfiles -march=rv64imafd -mabi=lp64 -mcmodel=medany -I$(BP_TEST_DIR)/include
RISCV_LINK = -static -nostartfiles -L$(BP_TEST_DIR)/lib -T src/riscv.ld

.PHONY: all bp-demo-riscv bp-demo-s

all: bp-demo-s bp-demo-riscv

bp-demo-riscv: $(foreach x,$(subst -,_,$(BP_DEMOS)),$(x).riscv)
bp-demo-s    : $(foreach x,$(subst -,_,$(BP_DEMOS_C)),$(x).s)

%.riscv:
	$(RISCV_GCC) $(RISCV_LINK) -o $@ src/$*.s -lperch

paging.riscv:
	$(RISCV_GCC) $(RISCV_LINK) -o $@ src/paging.s src/vm_start.S -lperch

mapping.riscv:
	$(RISCV_GCC) $(RISCV_LINK) -o $@ src/mapping.s src/vm_start.S -lperch

mc_sanity_%.s:
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -S -o src/mc_sanity_$(notdir $*).s src/mc_sanity.c

mc_template_%.s:
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -S -o src/mc_template_$(notdir $*).s src/mc_template.c

mc_rand_walk_%.s:
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -S -o src/mc_rand_walk_$(notdir $*).s src/mc_rand_walk.c

mc_work_share_sort_%.s:
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -S -o src/mc_work_share_sort_$(notdir $*).s src/mc_work_share_sort.c

%.s:
	$(RISCV_GCC) -S -o src/$@ src/$*.c

clean:
	rm -f *.riscv
	rm -f src/atomic_queue_demo_*.s
	rm -f src/mc_sanity_*.s
	rm -f src/mc_template_*.s
	rm -f src/mc_rand_walk_*.s
	rm -f src/mc_work_share_sort_*.s
	rm -f src/queue_demo_*.s
	rm -f $(foreach x,$(subst -,_,$(BP_DEMOS_C)),src/$(x).s)

