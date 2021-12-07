#ifndef CLINT_H
#define CLINT_H

#define CLINT_BASE 0x2000000

class CLINT
{
public:
    void set_interrupt_handler(unsigned long address);

    void enable_interrupt();
    void enable_software_interrupt();
    void enable_timer_interrupt();
    void enable_external_interrupt();

    void disable_interrupt();
    void disable_software_interrupt();
    void disable_timer_interrupt();
    void disable_external_interrupt();
};

extern "C" void machine_interrupt_redirect();
extern "C" void machine_interrupt_redirect_done();

#endif