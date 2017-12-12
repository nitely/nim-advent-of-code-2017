#[
--- Day 12: Digital Plumber ---

Walking along the memory banks of the stream, you find a small village that is experiencing a little confusion: some programs can't communicate with each other.

Programs in this village communicate using a fixed system of pipes. Messages are passed between programs using these pipes, but most programs aren't connected to each other directly. Instead, programs pass messages between each other until the message reaches the intended recipient.

For some reason, though, some of these messages aren't ever reaching their intended recipient, and the programs suspect that some pipes are missing. They would like you to investigate.

You walk through the village and record the ID of each program and the IDs with which it can communicate directly (your puzzle input). Each program has one or more programs with which it can communicate, and these pipes are bidirectional; if 8 says it can communicate with 11, then 11 will say it can communicate with 8.

You need to figure out how many programs are in the group that contains program ID 0.

For example, suppose you go door-to-door like a travelling salesman and record the following list:

0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5

In this example, the following programs are in the group that contains program ID 0:

    Program 0 by definition.
    Program 2, directly connected to program 0.
    Program 3 via program 2.
    Program 4 via program 2.
    Program 5 via programs 6, then 4, then 2.
    Program 6 via programs 4, then 2.

Therefore, a total of 6 programs are in this group; all but program 1, which has a pipe that connects it to itself.

How many programs are in the group that contains program ID 0?

]#

# This constructs the actual graph :)

import strutils
import tables
import sets

type
  Node = ref NodeObj
  NodeObj = object
    id: int
    neighbors: seq[Node]

proc visit(n: Node, visited: var HashSet[int]) =
  if n.id in visited:
    return
  visited.incl(n.id)
  for nn in n.neighbors:
    nn.visit(visited)

proc solve(n: string): int =
  # pre-populate hash table of nodes
  var nodes = newTable[int, Node]()
  for line in n.split("\n"):
    let id = line.split('<')[0].strip().parseInt
    nodes[id] = Node(id: id)
  # populate neighbors
  for line in n.split("\n"):
    let
      parts = line.split("<->")
      id = parts[0].strip().parseInt
    var neighbors: seq[int] = @[]
    for c in parts[1].split(','):
      neighbors.add(c.strip().parseInt)
    let node = nodes[id]
    node.neighbors = @[]
    for c in neighbors:
      node.neighbors.add(nodes[c])
  # look for the node 0
  var root: Node
  for id, node in nodes:
    if id == 0:
      root = node
      break
  assert(not root.isNil)
  # the actual solution
  var visited = initSet[int]()
  root.visit(visited)
  result = visited.len

echo $solve("""0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5""")
echo $solve("""0 <-> 46, 1376
1 <-> 1465, 1889
2 <-> 609, 1578
3 <-> 3, 1003, 1133, 1887
4 <-> 467, 1282
5 <-> 5, 460, 1059, 1812
6 <-> 235, 1318, 1556
7 <-> 885, 1143, 1400
8 <-> 8, 1102
9 <-> 1349
10 <-> 1711
11 <-> 1717
12 <-> 663, 1968
13 <-> 1374
14 <-> 55, 732, 926
15 <-> 255, 1133
16 <-> 645
17 <-> 180, 1507
18 <-> 401
19 <-> 531
20 <-> 20
21 <-> 467
22 <-> 1376, 1825
23 <-> 1163
24 <-> 93, 365, 383
25 <-> 46
26 <-> 1280
27 <-> 27
28 <-> 1001
29 <-> 1506, 1659
30 <-> 680, 1569
31 <-> 121, 172, 684
32 <-> 1331
33 <-> 527, 668, 1471
34 <-> 473
35 <-> 790, 1789
36 <-> 797
37 <-> 1832
38 <-> 1151, 1703
39 <-> 382
40 <-> 183, 333, 1032, 1405, 1587, 1649
41 <-> 589, 965
42 <-> 515, 1466
43 <-> 599
44 <-> 220, 1533
45 <-> 656
46 <-> 0, 25, 918, 1267
47 <-> 262, 1084, 1590
48 <-> 856
49 <-> 49
50 <-> 1604, 1650
51 <-> 233
52 <-> 1975
53 <-> 141, 296
54 <-> 54
55 <-> 14, 1483
56 <-> 738, 1632
57 <-> 698, 1089
58 <-> 133, 144, 1577
59 <-> 917
60 <-> 60, 694, 846
61 <-> 1386
62 <-> 264
63 <-> 1875
64 <-> 1028
65 <-> 83, 86, 1767, 1876
66 <-> 120
67 <-> 363
68 <-> 565
69 <-> 69
70 <-> 1414, 1542
71 <-> 782, 1149, 1918, 1944, 1951, 1974
72 <-> 72
73 <-> 73
74 <-> 77
75 <-> 81
76 <-> 519, 1266
77 <-> 74, 77
78 <-> 833, 1408, 1690
79 <-> 492
80 <-> 614, 1505
81 <-> 75, 81, 105, 595, 1035
82 <-> 440
83 <-> 65
84 <-> 106, 1907
85 <-> 508, 1397, 1811
86 <-> 65, 86, 112
87 <-> 682, 1872
88 <-> 1201
89 <-> 1297
90 <-> 592, 1873
91 <-> 1288, 1447
92 <-> 788, 1269, 1987
93 <-> 24, 97, 608
94 <-> 1138
95 <-> 1668
96 <-> 1608
97 <-> 93, 1446
98 <-> 580
99 <-> 220
100 <-> 1165, 1623
101 <-> 1588
102 <-> 1706, 1820
103 <-> 1187
104 <-> 561
105 <-> 81, 1419
106 <-> 84, 1055
107 <-> 140, 222
108 <-> 438, 1194
109 <-> 109, 1739
110 <-> 1217, 1968
111 <-> 650, 1213
112 <-> 86
113 <-> 250, 1380
114 <-> 248, 1172, 1254
115 <-> 115
116 <-> 713
117 <-> 319, 389
118 <-> 1892, 1914
119 <-> 227
120 <-> 66, 314, 350, 580
121 <-> 31, 1369, 1375
122 <-> 952, 1657
123 <-> 143, 1153
124 <-> 1124, 1173
125 <-> 125
126 <-> 1178
127 <-> 1406, 1966
128 <-> 620, 1493
129 <-> 541, 1095
130 <-> 1813
131 <-> 616
132 <-> 132, 1142
133 <-> 58, 163, 375
134 <-> 1288, 1503
135 <-> 534, 763
136 <-> 552
137 <-> 137, 762, 900
138 <-> 1791
139 <-> 502, 1768
140 <-> 107, 1150, 1346
141 <-> 53, 1415
142 <-> 1361
143 <-> 123, 729, 966, 1087, 1091
144 <-> 58, 1007, 1379
145 <-> 1183
146 <-> 543, 1569
147 <-> 600
148 <-> 735
149 <-> 828, 1558
150 <-> 442, 1096
151 <-> 228, 748
152 <-> 1076, 1951
153 <-> 1577
154 <-> 1829
155 <-> 376, 469, 789, 940, 1294
156 <-> 365, 1287
157 <-> 157
158 <-> 1372
159 <-> 504
160 <-> 1542
161 <-> 190
162 <-> 978
163 <-> 133, 671, 1173
164 <-> 776
165 <-> 437
166 <-> 231, 573, 1924
167 <-> 1661
168 <-> 1189
169 <-> 169, 907
170 <-> 230, 553
171 <-> 909
172 <-> 31, 234, 883
173 <-> 1062
174 <-> 174, 1688
175 <-> 597, 751, 1515, 1599
176 <-> 1302, 1435
177 <-> 177
178 <-> 427, 1148
179 <-> 1196, 1390
180 <-> 17, 847
181 <-> 528, 1956
182 <-> 482
183 <-> 40
184 <-> 184
185 <-> 307, 1339, 1555
186 <-> 703, 1198
187 <-> 1656
188 <-> 1342
189 <-> 1742
190 <-> 161, 237, 416, 590
191 <-> 907
192 <-> 482, 798, 1709
193 <-> 805, 1320
194 <-> 308, 989
195 <-> 316, 518, 728
196 <-> 848, 1239, 1335
197 <-> 681, 683, 1965, 1977
198 <-> 1028
199 <-> 1126, 1808, 1953
200 <-> 655, 921
201 <-> 733
202 <-> 1002, 1137, 1422
203 <-> 529, 1127
204 <-> 697, 1656
205 <-> 1249
206 <-> 608
207 <-> 669
208 <-> 241
209 <-> 1190
210 <-> 503
211 <-> 1017
212 <-> 567, 932, 1673
213 <-> 432
214 <-> 1097, 1180
215 <-> 715
216 <-> 426, 610, 1517
217 <-> 1638
218 <-> 1453
219 <-> 219, 1033
220 <-> 44, 99, 1874
221 <-> 221, 1466
222 <-> 107, 1014
223 <-> 495
224 <-> 503, 992
225 <-> 800
226 <-> 697, 1294
227 <-> 119, 733, 1186
228 <-> 151, 948, 984, 1359
229 <-> 1039
230 <-> 170, 1825, 1954
231 <-> 166, 894
232 <-> 580
233 <-> 51, 835, 1247
234 <-> 172, 588, 739
235 <-> 6, 812
236 <-> 1150
237 <-> 190, 1065, 1157
238 <-> 1930
239 <-> 345, 584, 1731
240 <-> 1514
241 <-> 208, 556, 784, 1992
242 <-> 242
243 <-> 1666, 1760
244 <-> 437, 1394
245 <-> 306, 1175
246 <-> 1032
247 <-> 522, 709, 1565, 1611
248 <-> 114, 248, 862, 1863
249 <-> 887, 1066
250 <-> 113
251 <-> 251
252 <-> 427, 1583
253 <-> 328
254 <-> 618, 680, 1370, 1442
255 <-> 15, 1516, 1637
256 <-> 470, 1532, 1678, 1809
257 <-> 448, 1263, 1434, 1587
258 <-> 519
259 <-> 296, 1877
260 <-> 311
261 <-> 1841
262 <-> 47, 1111
263 <-> 969
264 <-> 62, 264, 1347
265 <-> 1657
266 <-> 1360
267 <-> 494
268 <-> 1498
269 <-> 956, 1258
270 <-> 270, 532
271 <-> 400, 813, 1500
272 <-> 1777
273 <-> 1768
274 <-> 835, 1432
275 <-> 750
276 <-> 298, 1749
277 <-> 1256, 1285
278 <-> 1720
279 <-> 903
280 <-> 941
281 <-> 315, 1356
282 <-> 1293
283 <-> 667, 802
284 <-> 663, 1223
285 <-> 1732
286 <-> 493
287 <-> 584, 1823
288 <-> 365, 906
289 <-> 618, 1777
290 <-> 479, 988
291 <-> 794
292 <-> 304, 769, 944, 1448, 1735
293 <-> 516, 1295
294 <-> 406
295 <-> 1279
296 <-> 53, 259, 585, 1128
297 <-> 1047, 1899
298 <-> 276, 543
299 <-> 1268, 1528
300 <-> 993, 1384
301 <-> 1323, 1984
302 <-> 919, 923, 1611, 1962
303 <-> 1172
304 <-> 292
305 <-> 1857
306 <-> 245, 1044, 1699
307 <-> 185, 1138
308 <-> 194
309 <-> 1054
310 <-> 310, 1428, 1438
311 <-> 260, 1291
312 <-> 1316
313 <-> 441
314 <-> 120, 1865, 1967
315 <-> 281, 673, 711
316 <-> 195, 1083, 1969
317 <-> 317, 508
318 <-> 688
319 <-> 117
320 <-> 1174
321 <-> 822, 978, 1042, 1373, 1980
322 <-> 368, 1932
323 <-> 1192
324 <-> 1239
325 <-> 607, 704, 1871
326 <-> 634, 1916
327 <-> 940, 1605
328 <-> 253, 328, 636
329 <-> 722, 1528
330 <-> 1448
331 <-> 771, 820
332 <-> 1580
333 <-> 40, 1785
334 <-> 1992
335 <-> 1064, 1713
336 <-> 560, 1746, 1979
337 <-> 988
338 <-> 974, 1689, 1694
339 <-> 1468
340 <-> 555
341 <-> 426, 1068, 1976
342 <-> 1662
343 <-> 799, 860
344 <-> 743, 1109, 1547
345 <-> 239, 781, 1734, 1963
346 <-> 445, 1218, 1736
347 <-> 502, 1560
348 <-> 739, 1700
349 <-> 417
350 <-> 120, 887
351 <-> 533, 537
352 <-> 1075
353 <-> 506, 1098, 1248
354 <-> 354, 666
355 <-> 1320
356 <-> 464, 487, 1954
357 <-> 603, 1444, 1552
358 <-> 1273, 1623
359 <-> 1308, 1659
360 <-> 1648
361 <-> 361, 1822
362 <-> 362, 692
363 <-> 67, 606, 1127
364 <-> 364
365 <-> 24, 156, 288, 424, 1017
366 <-> 1006, 1434
367 <-> 372, 1413
368 <-> 322
369 <-> 1194
370 <-> 1272
371 <-> 1551
372 <-> 367
373 <-> 1077
374 <-> 1869
375 <-> 133
376 <-> 155
377 <-> 1373
378 <-> 982, 1730
379 <-> 556, 1999
380 <-> 1208, 1405
381 <-> 976, 1506, 1855
382 <-> 39, 1639
383 <-> 24, 894, 1215
384 <-> 1124, 1350
385 <-> 385, 417, 697, 845
386 <-> 491, 712, 817, 1550
387 <-> 1347
388 <-> 404
389 <-> 117, 1156, 1190
390 <-> 1344
391 <-> 679, 931, 989
392 <-> 396, 690, 1694
393 <-> 618, 1497, 1803
394 <-> 398, 1462
395 <-> 1230, 1417
396 <-> 392, 1412
397 <-> 818, 1176, 1951
398 <-> 394, 1651, 1945
399 <-> 1496
400 <-> 271, 1372, 1779, 1893
401 <-> 18, 1382
402 <-> 1726, 1864
403 <-> 1917
404 <-> 388, 1071
405 <-> 1026
406 <-> 294, 1354
407 <-> 1721, 1934
408 <-> 1523, 1600
409 <-> 923
410 <-> 410
411 <-> 856, 1190, 1568
412 <-> 714, 1423
413 <-> 736
414 <-> 953, 1631
415 <-> 1282
416 <-> 190, 659
417 <-> 349, 385
418 <-> 556, 912
419 <-> 1304
420 <-> 656
421 <-> 1230
422 <-> 422, 542
423 <-> 779, 1260
424 <-> 365, 1595
425 <-> 958, 1134, 1495
426 <-> 216, 341, 887
427 <-> 178, 252, 1609
428 <-> 428, 1257
429 <-> 1020
430 <-> 602
431 <-> 539
432 <-> 213, 938, 1633
433 <-> 629, 1705
434 <-> 640
435 <-> 447, 1694
436 <-> 1487
437 <-> 165, 244, 1661
438 <-> 108, 565, 966
439 <-> 663
440 <-> 82, 492
441 <-> 313, 441
442 <-> 150, 442, 1970
443 <-> 868, 1665
444 <-> 662, 823
445 <-> 346, 1043, 1660
446 <-> 691, 708
447 <-> 435, 1182
448 <-> 257, 1608
449 <-> 1771, 1959
450 <-> 893, 1299
451 <-> 1578
452 <-> 1607, 1725
453 <-> 533, 651, 1271
454 <-> 1366
455 <-> 1677
456 <-> 870, 1935
457 <-> 750
458 <-> 465, 1859
459 <-> 728
460 <-> 5
461 <-> 1070, 1937
462 <-> 1201, 1277
463 <-> 568
464 <-> 356, 1412
465 <-> 458, 1368, 1613, 1980
466 <-> 1385, 1993
467 <-> 4, 21, 1345
468 <-> 468, 707, 1721
469 <-> 155, 676, 1008
470 <-> 256, 667
471 <-> 1552
472 <-> 503, 1468
473 <-> 34, 473, 1638
474 <-> 531
475 <-> 1163, 1379
476 <-> 797
477 <-> 995
478 <-> 1258, 1441
479 <-> 290, 1257
480 <-> 1903
481 <-> 703, 1339
482 <-> 182, 192
483 <-> 500, 759, 1077
484 <-> 833
485 <-> 672, 828
486 <-> 661, 1784
487 <-> 356
488 <-> 688, 930
489 <-> 489, 579
490 <-> 490
491 <-> 386, 1580, 1715
492 <-> 79, 440, 767, 1872
493 <-> 286, 1538
494 <-> 267, 1674, 1902
495 <-> 223, 1655
496 <-> 572
497 <-> 532, 1038, 1401
498 <-> 498, 1241
499 <-> 614
500 <-> 483, 654, 1862, 1952
501 <-> 933, 1957
502 <-> 139, 347, 1629
503 <-> 210, 224, 472, 720, 1948
504 <-> 159, 1113
505 <-> 832, 913, 1707
506 <-> 353, 559, 1320
507 <-> 1870
508 <-> 85, 317, 722
509 <-> 1301, 1348, 1873
510 <-> 640, 1882
511 <-> 511
512 <-> 1300
513 <-> 1679, 1731
514 <-> 896, 1009
515 <-> 42, 1056
516 <-> 293
517 <-> 517, 1112, 1704
518 <-> 195
519 <-> 76, 258, 1247, 1782
520 <-> 661, 731, 1949
521 <-> 1179, 1762
522 <-> 247
523 <-> 668, 916, 1197
524 <-> 714, 1228, 1304
525 <-> 1479
526 <-> 1895
527 <-> 33
528 <-> 181, 528
529 <-> 203, 763, 1184, 1227, 1615
530 <-> 1169
531 <-> 19, 474, 1297, 1411, 1883
532 <-> 270, 497, 1630, 1821, 1868
533 <-> 351, 453
534 <-> 135, 1272
535 <-> 997, 1049
536 <-> 718, 1242
537 <-> 351, 1762
538 <-> 1165
539 <-> 431, 953, 1273
540 <-> 1062, 1362, 1554
541 <-> 129
542 <-> 422, 1713
543 <-> 146, 298
544 <-> 544
545 <-> 942, 1030, 1904
546 <-> 1553, 1598
547 <-> 974
548 <-> 845, 1479
549 <-> 1333
550 <-> 598
551 <-> 740, 1861
552 <-> 136, 1347, 1523
553 <-> 170, 915, 1603
554 <-> 1421
555 <-> 340, 760, 1836
556 <-> 241, 379, 418, 590
557 <-> 648
558 <-> 904, 1670
559 <-> 506, 1576, 1920
560 <-> 336, 1057, 1652
561 <-> 104, 1329, 1590
562 <-> 1297, 1322, 1702
563 <-> 1319
564 <-> 1331
565 <-> 68, 438, 1990
566 <-> 1031, 1240
567 <-> 212, 1146, 1436
568 <-> 463, 1093
569 <-> 1311, 1520
570 <-> 1065, 1893
571 <-> 1421
572 <-> 496, 587, 1082, 1537
573 <-> 166, 1556
574 <-> 1240
575 <-> 575
576 <-> 1157
577 <-> 1592
578 <-> 826
579 <-> 489, 986, 1458
580 <-> 98, 120, 232
581 <-> 1296, 1597
582 <-> 1439
583 <-> 1125, 1536
584 <-> 239, 287, 1152, 1743, 1834
585 <-> 296, 1189
586 <-> 952
587 <-> 572, 780, 1829
588 <-> 234, 1071, 1470
589 <-> 41, 1752
590 <-> 190, 556
591 <-> 1023
592 <-> 90, 1225, 1408
593 <-> 852, 1831
594 <-> 1760
595 <-> 81
596 <-> 1566
597 <-> 175
598 <-> 550, 765, 946, 1543
599 <-> 43, 1292, 1386, 1554
600 <-> 147, 1592
601 <-> 1025, 1586
602 <-> 430, 1028, 1522, 1812
603 <-> 357, 873
604 <-> 940
605 <-> 739, 1361
606 <-> 363, 630, 1828
607 <-> 325
608 <-> 93, 206
609 <-> 2
610 <-> 216
611 <-> 961, 1002
612 <-> 1193
613 <-> 892, 1090
614 <-> 80, 499, 1436
615 <-> 615, 1284
616 <-> 131, 1680, 1765
617 <-> 1017
618 <-> 254, 289, 393, 1308
619 <-> 1514
620 <-> 128, 1698
621 <-> 691
622 <-> 1844
623 <-> 811, 1323
624 <-> 745, 1429
625 <-> 959
626 <-> 1830
627 <-> 933
628 <-> 860, 1261, 1378, 1890
629 <-> 433, 1232
630 <-> 606, 1764
631 <-> 1836, 1986
632 <-> 806, 1297
633 <-> 717, 1539
634 <-> 326, 1646
635 <-> 1203, 1985
636 <-> 328
637 <-> 1894
638 <-> 1984
639 <-> 1669
640 <-> 434, 510, 996, 1683
641 <-> 844, 1166
642 <-> 816, 1865, 1953
643 <-> 1511
644 <-> 863, 1652
645 <-> 16, 1097, 1316, 1794
646 <-> 786
647 <-> 647
648 <-> 557, 1236
649 <-> 649
650 <-> 111
651 <-> 453, 888, 1207
652 <-> 795, 936, 1747
653 <-> 669
654 <-> 500, 1620
655 <-> 200, 1799
656 <-> 45, 420, 893, 1682
657 <-> 744
658 <-> 1106, 1293, 1493
659 <-> 416
660 <-> 1700
661 <-> 486, 520, 1067
662 <-> 444
663 <-> 12, 284, 439, 1627, 1922
664 <-> 726, 920, 1174
665 <-> 679
666 <-> 354
667 <-> 283, 470
668 <-> 33, 523
669 <-> 207, 653, 1740, 1806
670 <-> 1565, 1684
671 <-> 163
672 <-> 485
673 <-> 315
674 <-> 1161, 1617, 1714
675 <-> 1954
676 <-> 469, 1160, 1325, 1389
677 <-> 1664
678 <-> 1827
679 <-> 391, 665
680 <-> 30, 254, 750
681 <-> 197
682 <-> 87, 1751
683 <-> 197, 1724
684 <-> 31, 866
685 <-> 713
686 <-> 1911
687 <-> 1226
688 <-> 318, 488, 688, 1705
689 <-> 1127, 1343, 1769
690 <-> 392
691 <-> 446, 621, 1241
692 <-> 362, 1073
693 <-> 758, 1524, 1971
694 <-> 60, 1095
695 <-> 695
696 <-> 696, 1341
697 <-> 204, 226, 385, 824
698 <-> 57, 698
699 <-> 1219, 1429, 1566
700 <-> 935, 1487
701 <-> 826, 1197
702 <-> 1710
703 <-> 186, 481
704 <-> 325, 704
705 <-> 1607
706 <-> 1353, 1818
707 <-> 468
708 <-> 446, 945
709 <-> 247
710 <-> 1750
711 <-> 315
712 <-> 386
713 <-> 116, 685, 1250, 1662
714 <-> 412, 524
715 <-> 215, 833
716 <-> 1195
717 <-> 633, 737
718 <-> 536, 1633
719 <-> 1286, 1538
720 <-> 503, 1492, 1917
721 <-> 786, 1602
722 <-> 329, 508, 1251
723 <-> 1074, 1166
724 <-> 1715
725 <-> 1455
726 <-> 664, 927, 1121
727 <-> 1279
728 <-> 195, 459
729 <-> 143, 1929
730 <-> 785, 1269, 1826
731 <-> 520, 1907
732 <-> 14, 860
733 <-> 201, 227, 733
734 <-> 734
735 <-> 148, 1455, 1771
736 <-> 413, 1377, 1455
737 <-> 717, 1262, 1777
738 <-> 56
739 <-> 234, 348, 605
740 <-> 551, 790
741 <-> 1995
742 <-> 1435, 1768, 1814
743 <-> 344
744 <-> 657, 1857
745 <-> 624, 1283, 1745
746 <-> 1220
747 <-> 1253
748 <-> 151
749 <-> 1571
750 <-> 275, 457, 680
751 <-> 175, 1379, 1849
752 <-> 1577
753 <-> 842, 919
754 <-> 754
755 <-> 1609, 1941
756 <-> 756, 1451
757 <-> 1192, 1412
758 <-> 693, 1667
759 <-> 483
760 <-> 555
761 <-> 1389, 1641
762 <-> 137, 1280
763 <-> 135, 529, 1558
764 <-> 1239
765 <-> 598, 1420
766 <-> 1726
767 <-> 492
768 <-> 1697
769 <-> 292
770 <-> 882
771 <-> 331, 971, 1794
772 <-> 772, 809, 1365
773 <-> 1127
774 <-> 956, 981
775 <-> 1756
776 <-> 164, 1843
777 <-> 1224, 1252
778 <-> 778
779 <-> 423
780 <-> 587, 1295
781 <-> 345
782 <-> 71
783 <-> 1424, 1962
784 <-> 241
785 <-> 730, 1307, 1706
786 <-> 646, 721
787 <-> 1445
788 <-> 92, 1336
789 <-> 155, 1203
790 <-> 35, 740
791 <-> 1155
792 <-> 1818
793 <-> 1541
794 <-> 291, 794, 840, 1460
795 <-> 652, 1911
796 <-> 796
797 <-> 36, 476, 910, 1075
798 <-> 192, 1898
799 <-> 343, 905
800 <-> 225, 1334, 1488
801 <-> 1768
802 <-> 283, 1104, 1870
803 <-> 1484
804 <-> 804
805 <-> 193, 1331
806 <-> 632
807 <-> 830
808 <-> 1059
809 <-> 772, 1226
810 <-> 810
811 <-> 623
812 <-> 235, 1145, 1416
813 <-> 271, 1572
814 <-> 1257, 1886
815 <-> 1695
816 <-> 642
817 <-> 386
818 <-> 397, 1692
819 <-> 1551
820 <-> 331, 1177
821 <-> 1496
822 <-> 321
823 <-> 444, 1120, 1625
824 <-> 697
825 <-> 970
826 <-> 578, 701
827 <-> 1720
828 <-> 149, 485
829 <-> 1775
830 <-> 807, 1592, 1740
831 <-> 1578
832 <-> 505, 899, 1664
833 <-> 78, 484, 715, 916, 1054, 1403
834 <-> 1435
835 <-> 233, 274
836 <-> 1355, 1364
837 <-> 1032
838 <-> 1675, 1680
839 <-> 881, 1730
840 <-> 794
841 <-> 1250
842 <-> 753
843 <-> 1241, 1330, 1628
844 <-> 641
845 <-> 385, 548
846 <-> 60
847 <-> 180
848 <-> 196, 848
849 <-> 849
850 <-> 850
851 <-> 1392, 1439
852 <-> 593, 1151, 1421
853 <-> 1212, 1574
854 <-> 1051, 1065
855 <-> 866, 1390
856 <-> 48, 411
857 <-> 1018, 1526
858 <-> 1273
859 <-> 1541
860 <-> 343, 628, 732, 1385
861 <-> 1916
862 <-> 248, 1924
863 <-> 644, 1467
864 <-> 911
865 <-> 1115, 1667
866 <-> 684, 855
867 <-> 885, 1594
868 <-> 443
869 <-> 959, 1449
870 <-> 456, 1601, 1916
871 <-> 886
872 <-> 872, 1695
873 <-> 603
874 <-> 1396
875 <-> 1897
876 <-> 1315
877 <-> 1602
878 <-> 1578, 1969
879 <-> 1977
880 <-> 1158
881 <-> 839
882 <-> 770, 1136, 1390, 1544
883 <-> 172
884 <-> 1789
885 <-> 7, 867
886 <-> 871, 886
887 <-> 249, 350, 426
888 <-> 651
889 <-> 1768
890 <-> 1066, 1998
891 <-> 891
892 <-> 613, 942
893 <-> 450, 656
894 <-> 231, 383, 1485
895 <-> 1689
896 <-> 514
897 <-> 1395, 1873
898 <-> 1957
899 <-> 832
900 <-> 137, 1238, 1634, 1640
901 <-> 1563, 1633
902 <-> 911, 1312
903 <-> 279, 1066, 1337
904 <-> 558
905 <-> 799
906 <-> 288
907 <-> 169, 191
908 <-> 908
909 <-> 171, 983, 1309
910 <-> 797, 1540
911 <-> 864, 902, 1303
912 <-> 418
913 <-> 505, 940, 1835
914 <-> 914
915 <-> 553
916 <-> 523, 833
917 <-> 59, 1532
918 <-> 46, 1176, 1864
919 <-> 302, 753
920 <-> 664
921 <-> 200, 922, 1088, 1622
922 <-> 921
923 <-> 302, 409
924 <-> 924
925 <-> 925, 1103
926 <-> 14, 1013
927 <-> 726, 1725
928 <-> 1722
929 <-> 1088, 1932
930 <-> 488, 1719
931 <-> 391, 1750
932 <-> 212, 1258
933 <-> 501, 627
934 <-> 1146, 1693
935 <-> 700, 1713
936 <-> 652, 1530
937 <-> 1012
938 <-> 432
939 <-> 959
940 <-> 155, 327, 604, 913, 1012
941 <-> 280, 1087, 1288
942 <-> 545, 892, 1222
943 <-> 1828
944 <-> 292
945 <-> 708
946 <-> 598
947 <-> 1540, 1593
948 <-> 228
949 <-> 1104
950 <-> 950
951 <-> 1834
952 <-> 122, 586, 952, 1356, 1771, 1909
953 <-> 414, 539, 1876
954 <-> 980, 1199, 1578, 1815
955 <-> 955
956 <-> 269, 774, 956, 1023
957 <-> 1690
958 <-> 425, 1041
959 <-> 625, 869, 939
960 <-> 960
961 <-> 611
962 <-> 1188, 1594
963 <-> 1824
964 <-> 1391, 1982
965 <-> 41, 1332, 1656
966 <-> 143, 438, 1131, 1607
967 <-> 967
968 <-> 1737
969 <-> 263, 1243
970 <-> 825, 1089, 1125, 1988
971 <-> 771
972 <-> 1657
973 <-> 973
974 <-> 338, 547
975 <-> 975, 1213
976 <-> 381, 1860
977 <-> 1235, 1300
978 <-> 162, 321, 1736
979 <-> 979
980 <-> 954, 1493, 1521
981 <-> 774
982 <-> 378, 1687
983 <-> 909, 1581
984 <-> 228
985 <-> 1318
986 <-> 579, 989
987 <-> 1525, 1975
988 <-> 290, 337, 1488
989 <-> 194, 391, 986
990 <-> 1047
991 <-> 1276
992 <-> 224, 1900
993 <-> 300, 1677, 1921
994 <-> 1914
995 <-> 477, 1459, 1717
996 <-> 640
997 <-> 535, 1639
998 <-> 1834
999 <-> 1164, 1352, 1819
1000 <-> 1000
1001 <-> 28, 1001
1002 <-> 202, 611
1003 <-> 3
1004 <-> 1714
1005 <-> 1326, 1494, 1543
1006 <-> 366
1007 <-> 144, 1557
1008 <-> 469, 1029
1009 <-> 514, 1039
1010 <-> 1860
1011 <-> 1649, 1845
1012 <-> 937, 940
1013 <-> 926
1014 <-> 222, 1223
1015 <-> 1800
1016 <-> 1527, 1561
1017 <-> 211, 365, 617, 1452
1018 <-> 857, 1018
1019 <-> 1156, 1427, 1489
1020 <-> 429, 1087
1021 <-> 1197, 1773
1022 <-> 1861
1023 <-> 591, 956, 1846
1024 <-> 1024
1025 <-> 601, 1782
1026 <-> 405, 1026, 1050
1027 <-> 1335
1028 <-> 64, 198, 602
1029 <-> 1008
1030 <-> 545
1031 <-> 566
1032 <-> 40, 246, 837
1033 <-> 219, 1495
1034 <-> 1079, 1190, 1301, 1444, 1579
1035 <-> 81
1036 <-> 1621
1037 <-> 1605
1038 <-> 497, 1514
1039 <-> 229, 1009, 1382, 1965
1040 <-> 1116, 1596
1041 <-> 958
1042 <-> 321, 1171
1043 <-> 445
1044 <-> 306
1045 <-> 1432
1046 <-> 1965
1047 <-> 297, 990, 1047
1048 <-> 1599
1049 <-> 535
1050 <-> 1026
1051 <-> 854
1052 <-> 1410
1053 <-> 1819
1054 <-> 309, 833
1055 <-> 106, 1744
1056 <-> 515, 1919
1057 <-> 560, 1374, 1469, 1559
1058 <-> 1519, 1786
1059 <-> 5, 808
1060 <-> 1275, 1380, 1838
1061 <-> 1951
1062 <-> 173, 540, 1167
1063 <-> 1086
1064 <-> 335
1065 <-> 237, 570, 854
1066 <-> 249, 890, 903, 1854
1067 <-> 661
1068 <-> 341
1069 <-> 1202, 1370, 1844
1070 <-> 461
1071 <-> 404, 588, 1575
1072 <-> 1797
1073 <-> 692
1074 <-> 723, 1074
1075 <-> 352, 797
1076 <-> 152
1077 <-> 373, 483
1078 <-> 1291
1079 <-> 1034
1080 <-> 1915
1081 <-> 1081, 1510
1082 <-> 572, 1981
1083 <-> 316
1084 <-> 47
1085 <-> 1243
1086 <-> 1063, 1086, 1551
1087 <-> 143, 941, 1020, 1480
1088 <-> 921, 929
1089 <-> 57, 970
1090 <-> 613
1091 <-> 143
1092 <-> 1092
1093 <-> 568, 1573
1094 <-> 1458
1095 <-> 129, 694
1096 <-> 150, 1164
1097 <-> 214, 645, 1354, 1462, 1723
1098 <-> 353
1099 <-> 1272
1100 <-> 1386
1101 <-> 1332
1102 <-> 8
1103 <-> 925
1104 <-> 802, 949
1105 <-> 1105, 1304
1106 <-> 658, 1212, 1674
1107 <-> 1642, 1858
1108 <-> 1135, 1509
1109 <-> 344, 1184
1110 <-> 1562
1111 <-> 262, 1214, 1426, 1794
1112 <-> 517
1113 <-> 504, 1113, 1490, 1545
1114 <-> 1670
1115 <-> 865, 1115, 1636
1116 <-> 1040
1117 <-> 1486
1118 <-> 1145
1119 <-> 1393, 1406
1120 <-> 823, 1120, 1518
1121 <-> 726, 1121
1122 <-> 1375
1123 <-> 1123
1124 <-> 124, 384, 1827, 1853
1125 <-> 583, 970
1126 <-> 199
1127 <-> 203, 363, 689, 773, 1341, 1602
1128 <-> 296, 1610
1129 <-> 1562
1130 <-> 1476
1131 <-> 966
1132 <-> 1389
1133 <-> 3, 15
1134 <-> 425
1135 <-> 1108, 1970
1136 <-> 882
1137 <-> 202
1138 <-> 94, 307, 1287
1139 <-> 1139
1140 <-> 1484, 1658
1141 <-> 1361
1142 <-> 132
1143 <-> 7, 1143
1144 <-> 1357
1145 <-> 812, 1118
1146 <-> 567, 934
1147 <-> 1763
1148 <-> 178, 1779
1149 <-> 71
1150 <-> 140, 236, 1699
1151 <-> 38, 852, 1807
1152 <-> 584, 1906
1153 <-> 123
1154 <-> 1435, 1703
1155 <-> 791, 1303
1156 <-> 389, 1019
1157 <-> 237, 576, 1790
1158 <-> 880, 1653
1159 <-> 1836
1160 <-> 676, 1376
1161 <-> 674
1162 <-> 1874
1163 <-> 23, 475
1164 <-> 999, 1096
1165 <-> 100, 538
1166 <-> 641, 723
1167 <-> 1062
1168 <-> 1168, 1927
1169 <-> 530, 1748, 1775, 1995
1170 <-> 1521
1171 <-> 1042
1172 <-> 114, 303, 1687
1173 <-> 124, 163, 1298
1174 <-> 320, 664
1175 <-> 245
1176 <-> 397, 918
1177 <-> 820
1178 <-> 126, 1265
1179 <-> 521, 1926
1180 <-> 214
1181 <-> 1313
1182 <-> 447, 1837
1183 <-> 145, 1299, 1578, 1869
1184 <-> 529, 1109, 1816
1185 <-> 1494, 1972
1186 <-> 227, 1220
1187 <-> 103, 1688
1188 <-> 962
1189 <-> 168, 585
1190 <-> 209, 389, 411, 1034, 1206
1191 <-> 1191, 1477, 1639
1192 <-> 323, 757, 1461
1193 <-> 612, 1193
1194 <-> 108, 369
1195 <-> 716, 1392
1196 <-> 179
1197 <-> 523, 701, 1021
1198 <-> 186
1199 <-> 954
1200 <-> 1562
1201 <-> 88, 462, 1297
1202 <-> 1069
1203 <-> 635, 789
1204 <-> 1204, 1563
1205 <-> 1205, 1219
1206 <-> 1190
1207 <-> 651
1208 <-> 380
1209 <-> 1758
1210 <-> 1469
1211 <-> 1475, 1998
1212 <-> 853, 1106, 1836
1213 <-> 111, 975, 1216, 1932
1214 <-> 1111, 1709
1215 <-> 383
1216 <-> 1213
1217 <-> 110, 1394
1218 <-> 346
1219 <-> 699, 1205
1220 <-> 746, 1186
1221 <-> 1664
1222 <-> 942, 1672, 1946
1223 <-> 284, 1014
1224 <-> 777, 1278, 1655
1225 <-> 592
1226 <-> 687, 809
1227 <-> 529
1228 <-> 524
1229 <-> 1229
1230 <-> 395, 421
1231 <-> 1628
1232 <-> 629
1233 <-> 1732
1234 <-> 1813
1235 <-> 977, 1883
1236 <-> 648, 1539, 1708
1237 <-> 1977
1238 <-> 900
1239 <-> 196, 324, 764
1240 <-> 566, 574, 1516, 1531
1241 <-> 498, 691, 843
1242 <-> 536, 1780
1243 <-> 969, 1085, 1771, 1800
1244 <-> 1637
1245 <-> 1460
1246 <-> 1483, 1911
1247 <-> 233, 519
1248 <-> 353, 1440
1249 <-> 205, 1890
1250 <-> 713, 841, 1702
1251 <-> 722, 1882
1252 <-> 777
1253 <-> 747, 1659
1254 <-> 114
1255 <-> 1512, 1593
1256 <-> 277
1257 <-> 428, 479, 814
1258 <-> 269, 478, 932
1259 <-> 1901, 1920
1260 <-> 423, 1752
1261 <-> 628, 1328
1262 <-> 737
1263 <-> 257, 1943
1264 <-> 1837
1265 <-> 1178, 1958
1266 <-> 76
1267 <-> 46
1268 <-> 299, 1409
1269 <-> 92, 730
1270 <-> 1687
1271 <-> 453, 1457
1272 <-> 370, 534, 1099
1273 <-> 358, 539, 858
1274 <-> 1503
1275 <-> 1060, 1275
1276 <-> 991, 1551
1277 <-> 462
1278 <-> 1224, 1906
1279 <-> 295, 727, 1737
1280 <-> 26, 762
1281 <-> 1825
1282 <-> 4, 415
1283 <-> 745, 1813
1284 <-> 615
1285 <-> 277, 1285
1286 <-> 719, 1302
1287 <-> 156, 1138
1288 <-> 91, 134, 941
1289 <-> 1289
1290 <-> 1418, 1750
1291 <-> 311, 1078, 1291, 1582
1292 <-> 599
1293 <-> 282, 658, 1681, 1983
1294 <-> 155, 226
1295 <-> 293, 780, 1362
1296 <-> 581, 1643
1297 <-> 89, 531, 562, 632, 1201
1298 <-> 1173
1299 <-> 450, 1183, 1299, 1382, 1722
1300 <-> 512, 977, 1903
1301 <-> 509, 1034
1302 <-> 176, 1286, 1561, 1843
1303 <-> 911, 1155, 1850
1304 <-> 419, 524, 1105
1305 <-> 1472
1306 <-> 1615
1307 <-> 785, 1440
1308 <-> 359, 618, 1850
1309 <-> 909, 1984
1310 <-> 1400
1311 <-> 569, 1726
1312 <-> 902, 1830
1313 <-> 1181, 1673, 1945
1314 <-> 1725
1315 <-> 876, 1687
1316 <-> 312, 645
1317 <-> 1496, 1770
1318 <-> 6, 985
1319 <-> 563, 1999
1320 <-> 193, 355, 506
1321 <-> 1436
1322 <-> 562
1323 <-> 301, 623
1324 <-> 1757
1325 <-> 676, 1888
1326 <-> 1005, 1348
1327 <-> 1731
1328 <-> 1261, 1464, 1718
1329 <-> 561
1330 <-> 843
1331 <-> 32, 564, 805
1332 <-> 965, 1101
1333 <-> 549, 1666
1334 <-> 800
1335 <-> 196, 1027, 1534
1336 <-> 788
1337 <-> 903
1338 <-> 1439
1339 <-> 185, 481
1340 <-> 1340
1341 <-> 696, 1127
1342 <-> 188, 1636
1343 <-> 689
1344 <-> 390, 1368
1345 <-> 467, 1345
1346 <-> 140
1347 <-> 264, 387, 552, 1691
1348 <-> 509, 1326
1349 <-> 9, 1829
1350 <-> 384
1351 <-> 1408
1352 <-> 999
1353 <-> 706, 1910
1354 <-> 406, 1097
1355 <-> 836
1356 <-> 281, 952
1357 <-> 1144, 1666, 1701
1358 <-> 1358, 1422
1359 <-> 228, 1359
1360 <-> 266, 1360
1361 <-> 142, 605, 1141, 1364
1362 <-> 540, 1295, 1604
1363 <-> 1686, 1996
1364 <-> 836, 1361, 1554
1365 <-> 772, 1472
1366 <-> 454, 1366
1367 <-> 1367
1368 <-> 465, 1344
1369 <-> 121
1370 <-> 254, 1069
1371 <-> 1371
1372 <-> 158, 400
1373 <-> 321, 377
1374 <-> 13, 1057, 1546
1375 <-> 121, 1122
1376 <-> 0, 22, 1160
1377 <-> 736
1378 <-> 628
1379 <-> 144, 475, 751
1380 <-> 113, 1060
1381 <-> 1649
1382 <-> 401, 1039, 1299
1383 <-> 1383
1384 <-> 300, 1384
1385 <-> 466, 860, 1818
1386 <-> 61, 599, 1100, 1386
1387 <-> 1387
1388 <-> 1685
1389 <-> 676, 761, 1132
1390 <-> 179, 855, 882
1391 <-> 964
1392 <-> 851, 1195, 1553
1393 <-> 1119
1394 <-> 244, 1217, 1973
1395 <-> 897
1396 <-> 874, 1922
1397 <-> 85
1398 <-> 1730, 1905
1399 <-> 1735, 1879, 1885
1400 <-> 7, 1310, 1570
1401 <-> 497
1402 <-> 1402
1403 <-> 833, 1931
1404 <-> 1943
1405 <-> 40, 380, 1407, 1456
1406 <-> 127, 1119, 1502
1407 <-> 1405
1408 <-> 78, 592, 1351
1409 <-> 1268, 1662
1410 <-> 1052, 1618
1411 <-> 531
1412 <-> 396, 464, 757
1413 <-> 367, 1481
1414 <-> 70
1415 <-> 141
1416 <-> 812
1417 <-> 395, 1417
1418 <-> 1290, 1430, 1852
1419 <-> 105, 1762
1420 <-> 765
1421 <-> 554, 571, 852
1422 <-> 202, 1358, 1729
1423 <-> 412, 1665
1424 <-> 783, 1927
1425 <-> 1584
1426 <-> 1111
1427 <-> 1019
1428 <-> 310
1429 <-> 624, 699, 1459
1430 <-> 1418, 1588
1431 <-> 1518
1432 <-> 274, 1045, 1839
1433 <-> 1717
1434 <-> 257, 366
1435 <-> 176, 742, 834, 1154, 1507
1436 <-> 567, 614, 1321
1437 <-> 1572, 1732
1438 <-> 310
1439 <-> 582, 851, 1338, 1751, 1763
1440 <-> 1248, 1307
1441 <-> 478
1442 <-> 254
1443 <-> 1566
1444 <-> 357, 1034, 1844
1445 <-> 787, 1481, 1821
1446 <-> 97
1447 <-> 91
1448 <-> 292, 330
1449 <-> 869, 1748
1450 <-> 1581, 1648
1451 <-> 756, 1742
1452 <-> 1017
1453 <-> 218, 1499
1454 <-> 1454
1455 <-> 725, 735, 736, 1668
1456 <-> 1405
1457 <-> 1271
1458 <-> 579, 1094
1459 <-> 995, 1429, 1848
1460 <-> 794, 1245
1461 <-> 1192
1462 <-> 394, 1097
1463 <-> 1693
1464 <-> 1328
1465 <-> 1, 1901
1466 <-> 42, 221, 1513
1467 <-> 863
1468 <-> 339, 472
1469 <-> 1057, 1210
1470 <-> 588
1471 <-> 33
1472 <-> 1305, 1365, 1872
1473 <-> 1473
1474 <-> 1540, 1700
1475 <-> 1211
1476 <-> 1130, 1718
1477 <-> 1191
1478 <-> 1478
1479 <-> 525, 548
1480 <-> 1087
1481 <-> 1413, 1445, 1740
1482 <-> 1522
1483 <-> 55, 1246
1484 <-> 803, 1140
1485 <-> 894
1486 <-> 1117, 1486
1487 <-> 436, 700
1488 <-> 800, 988
1489 <-> 1019, 1685
1490 <-> 1113
1491 <-> 1546
1492 <-> 720, 1834
1493 <-> 128, 658, 980
1494 <-> 1005, 1185, 1535
1495 <-> 425, 1033, 1727
1496 <-> 399, 821, 1317
1497 <-> 393
1498 <-> 268, 1863
1499 <-> 1453, 1499
1500 <-> 271, 1647
1501 <-> 1733
1502 <-> 1406, 1574, 1960
1503 <-> 134, 1274
1504 <-> 1504
1505 <-> 80, 1711
1506 <-> 29, 381
1507 <-> 17, 1435
1508 <-> 1508, 1774
1509 <-> 1108
1510 <-> 1081
1511 <-> 643, 1562, 1772, 1920
1512 <-> 1255
1513 <-> 1466
1514 <-> 240, 619, 1038
1515 <-> 175, 1748
1516 <-> 255, 1240
1517 <-> 216, 1716, 1936
1518 <-> 1120, 1431
1519 <-> 1058, 1729
1520 <-> 569
1521 <-> 980, 1170
1522 <-> 602, 1482
1523 <-> 408, 552
1524 <-> 693, 1714
1525 <-> 987, 1525
1526 <-> 857, 1805
1527 <-> 1016
1528 <-> 299, 329
1529 <-> 1630, 1736
1530 <-> 936, 1712, 1908
1531 <-> 1240
1532 <-> 256, 917
1533 <-> 44
1534 <-> 1335
1535 <-> 1494
1536 <-> 583
1537 <-> 572
1538 <-> 493, 719
1539 <-> 633, 1236
1540 <-> 910, 947, 1474, 1741
1541 <-> 793, 859, 1793
1542 <-> 70, 160, 1542
1543 <-> 598, 1005
1544 <-> 882
1545 <-> 1113
1546 <-> 1374, 1491, 1716
1547 <-> 344
1548 <-> 1548
1549 <-> 1549
1550 <-> 386
1551 <-> 371, 819, 1086, 1276
1552 <-> 357, 471
1553 <-> 546, 1392
1554 <-> 540, 599, 1364
1555 <-> 185
1556 <-> 6, 573
1557 <-> 1007
1558 <-> 149, 763
1559 <-> 1057, 1559
1560 <-> 347
1561 <-> 1016, 1302
1562 <-> 1110, 1129, 1200, 1511
1563 <-> 901, 1204, 1964
1564 <-> 1564
1565 <-> 247, 670
1566 <-> 596, 699, 1443
1567 <-> 1929
1568 <-> 411
1569 <-> 30, 146, 1571
1570 <-> 1400, 1776
1571 <-> 749, 1569
1572 <-> 813, 1437, 1676
1573 <-> 1093, 1573
1574 <-> 853, 1502
1575 <-> 1071
1576 <-> 559, 1842
1577 <-> 58, 153, 752
1578 <-> 2, 451, 831, 878, 954, 1183
1579 <-> 1034
1580 <-> 332, 491
1581 <-> 983, 1450, 1942
1582 <-> 1291, 1824
1583 <-> 252, 1998
1584 <-> 1425, 1584
1585 <-> 1851
1586 <-> 601, 1877
1587 <-> 40, 257, 1713
1588 <-> 101, 1430
1589 <-> 1589
1590 <-> 47, 561
1591 <-> 1605
1592 <-> 577, 600, 830
1593 <-> 947, 1255
1594 <-> 867, 962
1595 <-> 424
1596 <-> 1040, 1687
1597 <-> 581, 1619
1598 <-> 546, 1778
1599 <-> 175, 1048
1600 <-> 408, 1938
1601 <-> 870
1602 <-> 721, 877, 1127
1603 <-> 553, 1955
1604 <-> 50, 1362
1605 <-> 327, 1037, 1591
1606 <-> 1875, 1887
1607 <-> 452, 705, 966
1608 <-> 96, 448
1609 <-> 427, 755
1610 <-> 1128
1611 <-> 247, 302
1612 <-> 1612
1613 <-> 465
1614 <-> 1841
1615 <-> 529, 1306
1616 <-> 1849
1617 <-> 674
1618 <-> 1410, 1758
1619 <-> 1597
1620 <-> 654, 1778
1621 <-> 1036, 1779
1622 <-> 921, 1851
1623 <-> 100, 358
1624 <-> 1728
1625 <-> 823
1626 <-> 1743
1627 <-> 663
1628 <-> 843, 1231
1629 <-> 502
1630 <-> 532, 1529
1631 <-> 414
1632 <-> 56, 1632
1633 <-> 432, 718, 901
1634 <-> 900, 1857
1635 <-> 1675, 1925
1636 <-> 1115, 1342, 1912
1637 <-> 255, 1244
1638 <-> 217, 473
1639 <-> 382, 997, 1191
1640 <-> 900
1641 <-> 761
1642 <-> 1107
1643 <-> 1296, 1643
1644 <-> 1945
1645 <-> 1997
1646 <-> 634
1647 <-> 1500
1648 <-> 360, 1450
1649 <-> 40, 1011, 1381, 1958
1650 <-> 50
1651 <-> 398
1652 <-> 560, 644
1653 <-> 1158, 1749
1654 <-> 1654
1655 <-> 495, 1224
1656 <-> 187, 204, 965
1657 <-> 122, 265, 972
1658 <-> 1140, 1658, 1718, 1744
1659 <-> 29, 359, 1253
1660 <-> 445, 1978
1661 <-> 167, 437
1662 <-> 342, 713, 1409
1663 <-> 1758, 1937
1664 <-> 677, 832, 1221, 1788
1665 <-> 443, 1423
1666 <-> 243, 1333, 1357, 1666
1667 <-> 758, 865, 1896
1668 <-> 95, 1455
1669 <-> 639, 1686, 1761
1670 <-> 558, 1114, 1670
1671 <-> 1769
1672 <-> 1222
1673 <-> 212, 1313
1674 <-> 494, 1106
1675 <-> 838, 1635
1676 <-> 1572
1677 <-> 455, 993
1678 <-> 256
1679 <-> 513
1680 <-> 616, 838, 1928
1681 <-> 1293
1682 <-> 656, 1881
1683 <-> 640, 1827
1684 <-> 670
1685 <-> 1388, 1489
1686 <-> 1363, 1669
1687 <-> 982, 1172, 1270, 1315, 1596, 1913
1688 <-> 174, 1187
1689 <-> 338, 895
1690 <-> 78, 957, 1764
1691 <-> 1347
1692 <-> 818
1693 <-> 934, 1463
1694 <-> 338, 392, 435
1695 <-> 815, 872
1696 <-> 1696
1697 <-> 768, 1697
1698 <-> 620
1699 <-> 306, 1150
1700 <-> 348, 660, 1474
1701 <-> 1357
1702 <-> 562, 1250
1703 <-> 38, 1154
1704 <-> 517
1705 <-> 433, 688, 1895
1706 <-> 102, 785
1707 <-> 505
1708 <-> 1236
1709 <-> 192, 1214
1710 <-> 702, 1791, 1840
1711 <-> 10, 1505
1712 <-> 1530
1713 <-> 335, 542, 935, 1587, 1923
1714 <-> 674, 1004, 1524, 1793
1715 <-> 491, 724, 1738
1716 <-> 1517, 1546, 1891
1717 <-> 11, 995, 1433
1718 <-> 1328, 1476, 1658
1719 <-> 930
1720 <-> 278, 827, 1798
1721 <-> 407, 468
1722 <-> 928, 1299, 1754, 1939
1723 <-> 1097
1724 <-> 683
1725 <-> 452, 927, 1314
1726 <-> 402, 766, 1311
1727 <-> 1495
1728 <-> 1624, 1937
1729 <-> 1422, 1519
1730 <-> 378, 839, 1398
1731 <-> 239, 513, 1327
1732 <-> 285, 1233, 1437
1733 <-> 1501, 1844
1734 <-> 345, 1759
1735 <-> 292, 1399
1736 <-> 346, 978, 1529
1737 <-> 968, 1279, 1737
1738 <-> 1715, 1809
1739 <-> 109
1740 <-> 669, 830, 1481
1741 <-> 1540
1742 <-> 189, 1451
1743 <-> 584, 1626
1744 <-> 1055, 1658
1745 <-> 745
1746 <-> 336, 1957, 1997
1747 <-> 652
1748 <-> 1169, 1449, 1515
1749 <-> 276, 1653, 1940
1750 <-> 710, 931, 1290
1751 <-> 682, 1439
1752 <-> 589, 1260
1753 <-> 1806
1754 <-> 1722
1755 <-> 1846
1756 <-> 775, 1756
1757 <-> 1324, 1757
1758 <-> 1209, 1618, 1663
1759 <-> 1734
1760 <-> 243, 594
1761 <-> 1669, 1878
1762 <-> 521, 537, 1419
1763 <-> 1147, 1439
1764 <-> 630, 1690
1765 <-> 616
1766 <-> 1833
1767 <-> 65
1768 <-> 139, 273, 742, 801, 889, 1781
1769 <-> 689, 1671
1770 <-> 1317, 1770
1771 <-> 449, 735, 952, 1243
1772 <-> 1511
1773 <-> 1021
1774 <-> 1508
1775 <-> 829, 1169
1776 <-> 1570
1777 <-> 272, 289, 737, 1950
1778 <-> 1598, 1620
1779 <-> 400, 1148, 1621
1780 <-> 1242
1781 <-> 1768
1782 <-> 519, 1025
1783 <-> 1836
1784 <-> 486
1785 <-> 333
1786 <-> 1058
1787 <-> 1858
1788 <-> 1664
1789 <-> 35, 884
1790 <-> 1157
1791 <-> 138, 1710, 1847
1792 <-> 1792
1793 <-> 1541, 1714
1794 <-> 645, 771, 1111
1795 <-> 1795
1796 <-> 1966
1797 <-> 1072, 1944
1798 <-> 1720, 1834
1799 <-> 655
1800 <-> 1015, 1243
1801 <-> 1801
1802 <-> 1802
1803 <-> 393
1804 <-> 1967
1805 <-> 1526
1806 <-> 669, 1753
1807 <-> 1151, 1844
1808 <-> 199
1809 <-> 256, 1738, 1918
1810 <-> 1810, 1840
1811 <-> 85
1812 <-> 5, 602
1813 <-> 130, 1234, 1283
1814 <-> 742
1815 <-> 954
1816 <-> 1184
1817 <-> 1817
1818 <-> 706, 792, 1385
1819 <-> 999, 1053
1820 <-> 102
1821 <-> 532, 1445
1822 <-> 361
1823 <-> 287
1824 <-> 963, 1582
1825 <-> 22, 230, 1281, 1861
1826 <-> 730, 1826
1827 <-> 678, 1124, 1683, 1880
1828 <-> 606, 943
1829 <-> 154, 587, 1349
1830 <-> 626, 1312
1831 <-> 593
1832 <-> 37, 1832
1833 <-> 1766, 1833
1834 <-> 584, 951, 998, 1492, 1798
1835 <-> 913
1836 <-> 555, 631, 1159, 1212, 1783
1837 <-> 1182, 1264
1838 <-> 1060
1839 <-> 1432
1840 <-> 1710, 1810
1841 <-> 261, 1614, 1867
1842 <-> 1576
1843 <-> 776, 1302
1844 <-> 622, 1069, 1444, 1733, 1807
1845 <-> 1011
1846 <-> 1023, 1755
1847 <-> 1791
1848 <-> 1459
1849 <-> 751, 1616
1850 <-> 1303, 1308
1851 <-> 1585, 1622
1852 <-> 1418
1853 <-> 1124
1854 <-> 1066
1855 <-> 381
1856 <-> 1925
1857 <-> 305, 744, 1634
1858 <-> 1107, 1787, 1858
1859 <-> 458
1860 <-> 976, 1010
1861 <-> 551, 1022, 1825
1862 <-> 500
1863 <-> 248, 1498
1864 <-> 402, 918
1865 <-> 314, 642
1866 <-> 1866
1867 <-> 1841, 1867
1868 <-> 532
1869 <-> 374, 1183, 1994
1870 <-> 507, 802
1871 <-> 325
1872 <-> 87, 492, 1472
1873 <-> 90, 509, 897
1874 <-> 220, 1162, 1957
1875 <-> 63, 1606
1876 <-> 65, 953
1877 <-> 259, 1586, 1907
1878 <-> 1761, 1989
1879 <-> 1399
1880 <-> 1827
1881 <-> 1682
1882 <-> 510, 1251
1883 <-> 531, 1235
1884 <-> 1884
1885 <-> 1399, 1885
1886 <-> 814
1887 <-> 3, 1606
1888 <-> 1325
1889 <-> 1
1890 <-> 628, 1249
1891 <-> 1716
1892 <-> 118
1893 <-> 400, 570
1894 <-> 637, 1937
1895 <-> 526, 1705
1896 <-> 1667, 1991
1897 <-> 875, 1976
1898 <-> 798
1899 <-> 297
1900 <-> 992
1901 <-> 1259, 1465
1902 <-> 494, 1917
1903 <-> 480, 1300
1904 <-> 545
1905 <-> 1398
1906 <-> 1152, 1278
1907 <-> 84, 731, 1877
1908 <-> 1530
1909 <-> 952
1910 <-> 1353
1911 <-> 686, 795, 1246
1912 <-> 1636
1913 <-> 1687
1914 <-> 118, 994, 1914
1915 <-> 1080, 1993
1916 <-> 326, 861, 870
1917 <-> 403, 720, 1902, 1933
1918 <-> 71, 1809
1919 <-> 1056
1920 <-> 559, 1259, 1511
1921 <-> 993
1922 <-> 663, 1396
1923 <-> 1713
1924 <-> 166, 862
1925 <-> 1635, 1856
1926 <-> 1179
1927 <-> 1168, 1424
1928 <-> 1680, 1928
1929 <-> 729, 1567
1930 <-> 238, 1933
1931 <-> 1403
1932 <-> 322, 929, 1213
1933 <-> 1917, 1930
1934 <-> 407
1935 <-> 456
1936 <-> 1517
1937 <-> 461, 1663, 1728, 1894, 1937
1938 <-> 1600
1939 <-> 1722
1940 <-> 1749
1941 <-> 755
1942 <-> 1581, 1967
1943 <-> 1263, 1404
1944 <-> 71, 1797
1945 <-> 398, 1313, 1644
1946 <-> 1222, 1946
1947 <-> 1998
1948 <-> 503
1949 <-> 520
1950 <-> 1777
1951 <-> 71, 152, 397, 1061
1952 <-> 500
1953 <-> 199, 642
1954 <-> 230, 356, 675
1955 <-> 1603
1956 <-> 181
1957 <-> 501, 898, 1746, 1874
1958 <-> 1265, 1649
1959 <-> 449
1960 <-> 1502
1961 <-> 1961
1962 <-> 302, 783
1963 <-> 345
1964 <-> 1563
1965 <-> 197, 1039, 1046
1966 <-> 127, 1796
1967 <-> 314, 1804, 1942
1968 <-> 12, 110
1969 <-> 316, 878
1970 <-> 442, 1135
1971 <-> 693
1972 <-> 1185
1973 <-> 1394, 1973
1974 <-> 71
1975 <-> 52, 987
1976 <-> 341, 1897
1977 <-> 197, 879, 1237
1978 <-> 1660
1979 <-> 336
1980 <-> 321, 465
1981 <-> 1082
1982 <-> 964, 1982
1983 <-> 1293
1984 <-> 301, 638, 1309
1985 <-> 635
1986 <-> 631
1987 <-> 92
1988 <-> 970
1989 <-> 1878, 1989
1990 <-> 565
1991 <-> 1896
1992 <-> 241, 334
1993 <-> 466, 1915
1994 <-> 1869
1995 <-> 741, 1169
1996 <-> 1363
1997 <-> 1645, 1746
1998 <-> 890, 1211, 1583, 1947
1999 <-> 379, 1319""")
