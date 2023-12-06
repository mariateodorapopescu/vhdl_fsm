# Bit-Drink Vending Machine

Welcome to the Bit-Drink Vending Machine project! 🥤🤖

In this project, we've designed an 8-bit vending machine that provides customers with two beverage options and accepts 1, 5, and 10 lei banknotes. The entire system is implemented in VHDL, a powerful hardware description language.

## How It Works

Here's a breakdown of how our vending machine operates:

- **Bill Slot:** The machine features a single bill slot that accepts 1, 5, and 10 lei banknotes sequentially. A bill sensor provides the processor with a 1-bit input `C`, which becomes 1 when a banknote is detected. Another 8-bit input `V` indicates the value of the banknote in lei.

- **Beverage Selection:** Two 8-bit inputs, `S0` and `S1`, represent the costs of the two beverage options. The values of `S0` and `S1` can be set by the owner of the vending machine. The choice is a 1-bit input to the machine (`Alegerea`), indicating the selected beverage type (0 for Beverage 0 with cost `S0` and 1 for Beverage 1 with cost `S1`).

- **Purchase Process:** If the deposited amount is less than the beverage cost, the processor generates an 8-bit output `P` to display the deposited amount. Once the processor detects banknotes whose value equals or exceeds the beverage cost, it sets a 2-bit output `D` for a clock cycle, determining the distribution of the beverage (00 or 11 for no action, 01 for dispensing Beverage 0, and 10 for dispensing Beverage 1).

- **Change Return:** The machine generates an 8-bit output `E` indicating that change should be returned in banknotes.

## How to Use

Each aspect of the vending machine's functionality is implemented in VHDL. The code provides a detailed understanding of the system's operation. Feel free to explore the implementation and reach out if you have any questions or suggestions. Quench your thirst for knowledge! 🚀🥤👩‍💻👨‍💻
