BinomialTrees
=============

This project implements a priority queue using min-binomial heaps Each value
within the priority queue needs to have a score assigned, according to which
its position within the queue is computed.

The queues can be interfaced with directly, or via a GenServer interface.

This lends itself naturally to use unix timestamps as scores, allowing this
module to act as a simple time-based queueing server.

Note that traditional queuing server functionality such as persistence or
protection against lost jobs when an exception is raised after a job is removed
from the queue are not part of the provided functionality as of the time of
this writing.

For more information on binomial heaps, see
https://en.wikipedia.org/wiki/Binomial_heap

Functions
=========

The following functionality is implemented for the queues:
add(), min(), pop(), min_pop() and size().
