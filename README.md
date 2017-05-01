FlowUni
==============

(This is the graduation project for Zhixuan Yang's bachelor degree at *Peking University*)

It is a powerful points-to analysis tool with the following features:

1. flow-sensitive
2. context-sensitive
3. heap cloning
4. unification-based

Context-sensitivity and heap cloning are implemented in a bottom-up-summarization way, and are sacrificed in a strong connected component (Similar to Chris Lattner's DSA).

Flow-sensitivity is implemented as a *sparse analysis* on the memory SSA form (Calvin Lin's method (DSA is used to build memory SSA)).

Motivation
==============

The reason for me to build such a complicated points-to analysis is to use it for statically fixing memory leaks, where you need a flow-sensitive and heap-cloning points-to information.
