#define - $s0 store size of array
#       - $s1 store elements of array

.data
	array: .word 100
	
        Space: .asciiz " "
        Enter: .asciiz "\n"
        GetNumOfElement: .asciiz "\nNhap vao su lua chon cua ban: "
        GetSizeOfArray: .asciiz "\nNhap vao so luong phan tu: "
        Getx: .asciiz "\nNhap vao phan tu can tim: "
        ShowOption: .asciiz "\n----------------MENU----------------\n1. Xuat ra cac phan tu\n2. Tinh tong cac phan tu\n3. Liet ke cac phan tu la so nguyen to\n4. Max\n5. Find element\n6. Exit"
 	Result: .asciiz "\nKet qua: "
 	comma: .asciiz  ", "
        
.text

.globl main
main:
	jal getSize
	j EXIT

getSize: 
	la $a0, GetSizeOfArray
	li $v0, 4
	syscall
	
	li, $v0, 5
	syscall	
	blez $v0, getSize
	move $s0, $v0 #s0 register store size of array	
	move $t0, $s0 #create a copy of $s0
	la $s1, array
	jal getInput

getInput:
	beq $t0, 0, MENU
	
	li $v0, 5
	syscall
	sw $v0, ($s1)
	addi $t0, $t0, -1
	addi $s1, $s1, 4
	b getInput

MENU: 
	#Print menu 
	li $v0, 4
	la $a0, ShowOption
	syscall
	
	li $v0, 4
	la $a0, GetNumOfElement
	syscall
	
	#Nhap so nguyen
	li $v0, 5
	syscall
	
	#Luu tru so nguyen vua nhap vao $t0
	add $t0, $v0, $0
	
	bgt $t0, 6, MENU
	blez $t0, MENU
	
	beq $t0, 1, output
	beq $t0, 2, sum
	
	beq $t0, 4, max
	beq $t0, 5, findPos
	jal EXIT
	
output: 

	la $a0, Result
	li, $v0, 4
	syscall
	
	move $t0, $s0 #copy size of array to $t0
	la $s1, array #load array address
	jal output_loop
	
output_loop:
	beq $t0, 0, MENU
	
	lw $t2, ($s1)
	move $a0, $t2
	li, $v0, 1
	syscall
	
	la $a0, comma
	li, $v0, 4
	syscall
	
	addi $t0, $t0, -1
	addi $s1, $s1, 4
	
	b output_loop
	
sum: 
	la $a0, Result
	li $v0, 4
	syscall
	
	move $t0, $s0
	la $s1, array
	li $a0, 0 #$a0 is store sum of array
	jal sum_loop
	
	
sum_loop:
	beq $t0, 0, sumResult
	
	lw $t2, ($s1)
	add $a0, $a0, $t2
	
	addi $t0, $t0, -1
	addi $s1, $s1, 4
	
	b sum_loop
	
sumResult:
	
	li $v0,1 
  	syscall   
	
	jal MENU
	
max: 
	la $a0, Result
	li $v0, 4
	syscall
	
	move $t0, $s0
	la $s1, array
	lw $a0, ($s1) #$a0 now store the first element of array
	
	jal max_loop

max_loop:
	beq $t0, 0 maxResult
	
	lw $t2, ($s1)
	bgt $t2, $a0, setNewMaxValue
	
	addi $t0, $t0, -1
	addi $s1, $s1, 4
	
	b max_loop
	
setNewMaxValue:
	move $a0, $t2
	jal max_loop

maxResult:
	li $v0,1 
  	syscall   
	
	jal MENU	
	
findPos:
	li $v0, 4
	la $a0, Getx
	syscall
	
	#Nhap so nguyen
	li $v0, 5
	syscall
	
	move $a0, $v0 #a0 store x
	
	move $t0, $s0
	la $s1, array
	jal findPos_loop
	
findPos_loop:
	beq $t0, 0, falseLabel
	
	lw $t2, ($s1)
	beq $t2, $a0, trueLabel
	
	addi $t0, $t0, -1
	addi $s1, $s1, 4
	
	b findPos_loop
	
trueLabel:
	sub $a0, $s0, $t0	
	li $v0,1 
  	syscall   
	
	jal MENU	
	
falseLabel:
	li $a0, -1
	li $v0, 1
	syscall	
	
	jal MENU
	
EXIT: 
	#Ket thuc chuong trinh
	addi $v0, $0 10
	syscall 


