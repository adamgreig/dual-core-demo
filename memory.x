MEMORY
{
  /* First flash bank, 1MB in 8x128K sectors. */
  FLASH1 : ORIGIN = 0x08000000, LENGTH = 1M

  /* Second flash bank, 1MB in 8x128K sectors. */
  FLASH2 : ORIGIN = 0x08100000, LENGTH = 1M

  /* DTCM RAM, two contiguous 64KB RAMs, used for stacks and general RAM.
   * Only accessible to the Cortex-M7 core. Zero wait-states.
   */
  DTCMRAM : ORIGIN = 0x20000000, LENGTH = 128K

  /* AXISRAM, 512KB accessible by all system masters except BDMA,
   * suitable for application data not stored in DTCM. Zero wait-states.
   */
  AXISRAM : ORIGIN = 0x24000000, LENGTH = 512K

  /* AHB SRAM, SRAM1-3 are in D2 and accessible by all system masters
   * except BDMA, suitable for use as DMA buffers. SRAM4 is in D3 and
   * additionally accessible by the BDMA, used for BDMA buffers, for
   * storing application data in lower-power modes, or for sharing
   * data between the Cortex-M4 and -M7 cores. Zero wait-states.
   */
  SRAM1 : ORIGIN = 0x30000000, LENGTH = 128K
  SRAM2 : ORIGIN = 0x30020000, LENGTH = 128K
  SRAM3 : ORIGIN = 0x30040000, LENGTH = 32K
  SRAM4 : ORIGIN = 0x38000000, LENGTH = 64K

  /* Backup SRAM, used to store data during low-power sleeps. */
  BSRAM : ORIGIN = 0x38800000, LENGTH = 4K

  /* Instruction TCM. Used for latency-critical interrupt handlers etc. */
  ITCM  : ORIGIN = 0x00000000, LENGTH = 64K
}

/* Provide FLASH and RAM for cortex-m-rt's linker script. */
REGION_ALIAS(FLASH, FLASH1);
REGION_ALIAS(RAM, DTCMRAM);

/* Define sections for placing symbols into the extra memory regions above. */
SECTIONS {
  .axisram (NOLOAD) : ALIGN(8) {
    *(.axisram .axisram.*);
    . = ALIGN(8);
    } > AXISRAM

  .sram1 (NOLOAD) : ALIGN(4) {
    *(.sram1 .sram1.*);
    . = ALIGN(4);
    } > SRAM1

  .sram2 (NOLOAD) : ALIGN(4) {
    *(.sram2 .sram2.*);
    . = ALIGN(4);
    } > SRAM2

  .sram3 (NOLOAD) : ALIGN(4) {
    *(.sram3 .sram3.*);
    . = ALIGN(4);
    } > SRAM3

  .sram4 (NOLOAD) : ALIGN(4) {
    *(.sram4 .sram4.*);
    . = ALIGN(4);
    } > SRAM4

  .itcm : ALIGN(4) {
    *(.itcm .itcm.*);
    . = ALIGN(4);
  } > ITCM AT > FLASH

  .flash2 : ALIGN(4) {
   KEEP(*(.flash2.vector_table));
   *(.flash2 .flash2.*);
   . = ALIGN(4);
  } > FLASH2
}
