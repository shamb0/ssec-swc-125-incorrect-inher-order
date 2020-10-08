# ssec-swc-125-incorrect-inher-order | Solidity | Security | SWC-125 | Incorrect Inheritance Order

**Description**

Solidity supports multiple inheritance, meaning that one contract can inherit several contracts. Multiple inheritance introduces ambiguity called Diamond Problem: if two or more base contracts define the same function, which one should be called in the child contract? Solidity deals with this ambiguity by using reverse C3 Linearization, which sets a priority between base contracts.

That way, base contracts have different priorities, so the order of inheritance matters. Neglecting inheritance order can lead to unexpected behavior.

**Remediation**

When inheriting multiple contracts, especially if they have identical functions, a developer should carefully specify inheritance in the correct order. The rule of thumb is to inherit contracts from more /general/ to more /specific/.

---

## Reference

* [SWC-125 · Overview](https://swcregistry.io/docs/SWC-125)

---


