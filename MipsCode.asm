.data
 	prompt: .asciiz "Enter a string: "
 	userInput: .space 1001
 	errorMessage: .asciiz "NaN"
 .text
 	main:
 		#dsiplays the prompt saying the user to input data
 		li $v0, 4 		#tells the system to be ready for printing string
 		la $a0, prompt          #loads address of prompt to $a0
 		syscall			#prints the string
 		
 		#gets input from the user
 		li $v0, 8
 		la $a0, userInput	#loads the address of the userInput in $a0
 		li $a1, 1001		#specifies the number of bytes to read
		syscall
		
		#reading character in a string
		#loading the address of first character and storing it
		la $s1, userInput	#loads the address of the first character of the userInput in $s1
		lb $t1, 0($s1)		#loads the first character into $t1
		beq $t1, 10, noInput	#branches to noInput if $t1 == end of line
		
		li $t6, 0				 #initializing $t6 to be 0
		li $t6, 0				 #initializing $t6 to be 0 
							 #later used for storing end of substring
		li $t5, 0 				 #initializing $t5 to be 0
		li $t1, 0				 #used for knowing the last substring
							 #later used for storing start of required substring
		li $t1, 0				 #used to update if the substring is last or not
		
		#goes through the userInput
		#divides the input into substrings for conversion
		loop:
			#checks for spaces at the front and end of string and removes it
			loopTempEnd:
				add $t0, $s1, $t6		 #adds contents of $t6 and $s1 and stores it in $t0
				lb $t2, 0($t0)   	 	 #loads the content stored in $t0 to $t2
				beq $t2, $zero, lastSubString	 
				beq $t2, 10, lastSubString
				beq $t2, 44, loopStartIndex
				addi $t6, $t6, 1
				j loopTempEnd		 	
				beq $t2, $zero, lastSubString	 #goes to lastSubStirng if $t2 is newline character 
				beq $t2, 10, lastSubString	 #goes to lastSubString if $t2 is endofline character
				beq $t2, 44, loopStartIndex	 #jumps to loopStartIndex if $t2 is ',' 
				addi $t6, $t6, 1		 #$t6 = $t6 + 1
				j loopTempEnd		 	 
			#tempEnd is in $t6
			#it's the end of the substring
			
			#used for knowing the last substring
			lastSubString:
				addi $t1,$t1, 1			 #$t1 = $t1 + 1
				j loopStartIndex
 			#gives the proper starting index of sub-string
			#the first character which is not space or tab
			loopStartIndex:
				add $t0, $s1, $t5		 #adds $s1 and $s2 and stores it in $t0
				lb $t2, 0($t0)			 #loads the content of $t0 into $t2
 				beq $t2, 9, continue		 #jumps to cont if $t2 == tab
 				beq $t2, ' ', continue		 #jumps to cont if character is space
 				j loopEndIndex			 #jumps to loopEndIndex
 				continue:	
				addi $t5, $t5, 1		 #adds 1 to $s2 and stores it in $s2
				j loopStartIndex		 #jumps back to loopStartIndex
  			#startIndex is in $t5
  			#it's the first character which is not space or tab
  			
  			#gives the address of the last character of the substring
  			#the last character is not the actual last character
  			addi $t4, $t6, 0 			 #adds $t6 and 0 and stores the value in $t4
  			loopEndIndex:
  				add $t0, $s1, $t4		 #adds $s1 and $t4 and stores in $t0		 
				lb $t2, 0($t0)			 #loads the char at $t0 into $t2
				beq $t2, 9, continue1
				beq $t2, ' ', continue1
				jal subProgram_2		
				
				jal subProgram_2	
	
				beq $t1, 1, subProgram_3	 #goes to subProgram_3 if $t1 == 1
				
				continue1:	 
				
				addi $t4, $t4, -1
				j loopEndIndex
			#endIndex is in $t4
 			
 			continue3:
 			addi $t6, $t6, 1			 #incrementing $t6 by 1
 			addi $t5, $t6, 0			 #$t5 = $t6	
 		
 		
 	#informs system to end main
 	Exit:
 		li $v0, 10
 		syscall
 	
 	invalidString:
 		li $v0, 4
 		la $a0, errorMessage
 		jr $ra
 					
 	#displays the errorMessage and jumps to Exit
 	noInput:
 		li $v0, 4
 		la $a0, errorMessage	
 		syscall
 		j Exit
	
	#displays the output
	subProgram_3:
		li $v0, 1
		addi $a3, $s2, 0
		syscall
		j continue3
	
	#converts a single hexadecimal string to a decimal string		
	subProgram_2:
		li $s2, 0 				 #initializing $s2 to be 0
							 #the converted decimal value will be stored here
		
							 
		#checking the length of the substring and checking its validity
		sub $t3, $t4, $t5			 #subtracts $t4 from $t5 and stores the result in $t3
		li $t7, 8
 		blt $t3, $t7, continue2			 #goes to continue2 if $t3 is less than $t7
 		j invalidString				 #jumps to invalidString
		
		#loops through each character of the subtring
		continue2:
			lb $t2, 0($t5)			 #loads the char in $t5 to $t2
			add $t0, $s1, $t5
			lb $t2, 0($t0)			 #loads the char in $t5 to $t2
			jal checkChar
			beq $v1, 0, invalidString	 #goes to invalidString if $v1 is 0
			jal subprogram_1	
			sll $s2, $s2, 4			 #shift left $s2 by 1 byte
			add $s2, $s2, $t2
			addi $t5, $t5, 1		 #$t5 = $t5 + 1
			beq $t5, $t4, subProgram_3
			beq $t5, $t4, continue3		 #jumps back to loop
		#-------------------------------------------------------------------
