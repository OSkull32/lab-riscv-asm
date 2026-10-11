        .data
        .globl  array
array:  .word   3,  -7,  12,   5
        .word   0,   9,  -2,  44
        .word  18, -25,   6,   7
        .word  11,   4,  13, -25
        .word  -1,   8,   2,  30

msg:    .asciiz "min = "
nl:     .asciiz "\n"

        .text
        .globl main

main:
        la      a0, array          # a0 = адрес массива
        li      a1, 5              # a1 = N = 5
        li      a2, 4              # a2 = M = 4
        jal     ra, min_element    # вызов функции; результат вернётся в a0

        mv      s0, a0             # сохраняем результат между системными вызовами

        la      a1, msg            # print_string: адрес строки "min = " в a1
        li      a0, 4
        ecall

        mv      a1, s0             # print_int: число в a1
        li      a0, 1
        ecall

        la      a1, nl             # перевод строки
        li      a0, 4
        ecall

        li      a0, 10             # exit
        ecall

# Регистры функции:
#   s0 - текущий минимум
#   s1 - счётчик оставшихся строк
#   s2 - количество столбцов m
#   t0 - адрес начала текущей строки
#   t1 - счётчик оставшихся элементов в строке
#   t2 - адрес текущего элемента
#   t3 - значение текущего элемента
#   t4 - смещение строки в байтах (m * 4)

        .globl  min_element
min_element:
        # сохраняем на стеке ra и используемые s-регистры (ABI).
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
        sw      s2, 0(sp)

        lw      s0, 0(a0)          # min = a[0][0]
        mv      s1, a1             # s1 = n
        mv      s2, a2             # s2 = m
        mv      t0, a0             # t0 = адрес начала первой строки

row_loop:
        beqz    s1, done           # все строки обработаны?
        mv      t1, s2             # t1 = m
        mv      t2, t0             # t2 = адрес первого элемента строки

col_loop:
        beqz    t1, next_row       # строка пройдена?
        lw      t3, 0(t2)          # t3 = a[i][j]
        bge     t3, s0, skip       # если a[i][j] >= min, минимум не меняется
        mv      s0, t3             # иначе запоминаем новый минимум
skip:
        addi    t2, t2, 4          # следующий элемент (int = 4 байта)
        addi    t1, t1, -1
        j       col_loop

next_row:
        slli    t4, s2, 2          # t4 = m * 4 - длина строки в байтах
        add     t0, t0, t4         # t0 = начало следующей строки
        addi    s1, s1, -1
        j       row_loop

done:
        mv      a0, s0             # возвращаемое значение - минимум

        # восстанавливаем сохранённые регистры.
        lw      ra, 12(sp)
        lw      s0, 8(sp)
        lw      s1, 4(sp)
        lw      s2, 0(sp)
        addi    sp, sp, 16
        ret
