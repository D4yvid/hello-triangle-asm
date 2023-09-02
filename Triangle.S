.section .data
	GL_COLOR_BUFFER_BIT:		.long	0x00004000

	GLFW_CONTEXT_VERSION_MAJOR:	.long	0x00022002
	GLFW_CONTEXT_VERSION_MINOR:	.long	0x00022003
	GLFW_RESIZEABLE:		.long	0x00020003

	title:
		.ascii	"assembly lol"
		.byte	0x00
	window:	.long 0x00000000

	clearcolor.r:	.float	0.3
	clearcolor.g:	.float	0.5
	clearcolor.b:	.float	1.0
	clearcolor.a:	.float	1.0

	tricolor.r:	.float	0.1
	tricolor.g:	.float	0.1
	tricolor.b:	.float	0.1

	trivert1.x:	.float	-0.5
	trivert1.y:	.float	-0.5
	trivert1.z:	.float	 0.0
	
	trivert2.x:	.float	 0.5
	trivert2.y:	.float	-0.5
	trivert2.z:	.float	 0.0

	trivert3.x:	.float	 0.0
	trivert3.y:	.float	 0.5
	trivert3.z:	.float	 0.0

.section .text
.global main

check_shader_compilation:
	push	%rbp
	mov	%rbp,	%rsp

	mov	%rsp,	%rbp
	pop	%rbp
	ret

main:
	# Align stack
	mov	%rsp,	%rbp
	sub	$0x08,	%rsp

	# Initialize GLFW
	call	glfwInit
	cmp	$0x00,	%rax
	je	.L0

	# Make the window un-resizeable
	mov	GLFW_RESIZEABLE,		%rdi
	mov	$0x00,				%rsi
	call	glfwWindowHint
	
	# Create GLFW window
	mov	$640,		%rdi	# width
	mov	$480,		%rsi	# height
	mov	$title,		%rdx	# title
	mov	$0x00,		%rcx	# monitor
	mov	$0x00,		%r8	# share
	call	glfwCreateWindow

	mov	%rax,	window

	cmp	$0x00,	%rax
	je	.L0

	# Make the new OpenGL context in the window
	mov	window,	%rdi
	call	glfwMakeContextCurrent

	# Set the clear color to blue
	movss	clearcolor.r,	%xmm0
	movss	clearcolor.g,	%xmm1
	movss	clearcolor.b,	%xmm2
	movss	clearcolor.a,	%xmm3
	call	glClearColor

.L1:	# Loop until the window hasn't closed
	mov	window,	%rdi
	call	glfwWindowShouldClose
	cmp	$0x01,	%rax
	je	.L2

	# Draw something into the screen
	mov	GL_COLOR_BUFFER_BIT,	%rdi
	call	glClear

	mov	$0x04,	%rdi
	call	glBegin

	movss	tricolor.r,	%xmm0
	movss	tricolor.g,	%xmm1
	movss	tricolor.b,	%xmm2
	call	glColor3f

	movss	trivert1.x,	%xmm0
	movss	trivert1.y,	%xmm1
	movss	trivert1.z,	%xmm2
	call	glVertex3f

	movss	trivert2.x,	%xmm0
	movss	trivert2.y,	%xmm1
	movss	trivert2.z,	%xmm2
	call	glVertex3f

	movss	trivert3.x,	%xmm0
	movss	trivert3.y,	%xmm1
	movss	trivert3.z,	%xmm2
	call	glVertex3f

	call	glEnd

	# Poll all window events
	mov	$0x00,	%rdi
	call	glfwPollEvents

	# Swap all buffers
	mov	window,	%rdi
	call	glfwSwapBuffers

	jmp	.L1

.L2:
	call	glfwTerminate

	mov	$0x00,	%rdi
	jmp	.main.exit

.L0:
	mov	$0x01,	%rdi

.main.exit:
	# Exit
	mov	$0x3c,	%rax
	syscall

	add	$0x08,	%rsp
	mov	%rsp,	%rbp
	ret
