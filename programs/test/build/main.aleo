program test.aleo;

struct Ciphertext:
    value_ as group;
    nonce as group;




function gen_address:
    input r0 as scalar.private;
    mul r0 522678458525321116977504528531602186870683848189190546523208313015552693483group into r1;
    cast r1 into r2 as address;
    cast r2 into r3 as address;
    output r3 as address.private;




function sum:
    input r0 as Ciphertext.private;
    input r1 as Ciphertext.private;
    add r0.value_ r1.value_ into r2;
    add r0.nonce r1.nonce into r3;
    cast r2 r3 into r4 as Ciphertext;
    output r4 as Ciphertext.private;






function test:
    input r0 as scalar.private;
    input r1 as scalar.private;
    input r2 as scalar.private;
    input r3 as scalar.private;
    input r4 as scalar.private;
    mul r0 522678458525321116977504528531602186870683848189190546523208313015552693483group into r5;
    cast r5 into r6 as address;
    cast r6 into r7 as address;
    mul r2 522678458525321116977504528531602186870683848189190546523208313015552693483group into r8;
    cast r8 into r9 as address;
    cast r9 into r10 as group;
    cast r7 into r11 as group;
    mul r2 r11 into r12;
    mul r1 group::GEN into r13;
    add r13 r12 into r14;
    cast r14 r10 into r15 as Ciphertext;
    mul r4 522678458525321116977504528531602186870683848189190546523208313015552693483group into r16;
    cast r16 into r17 as address;
    cast r17 into r18 as group;
    cast r7 into r19 as group;
    mul r4 r19 into r20;
    mul r3 group::GEN into r21;
    add r21 r20 into r22;
    cast r22 r18 into r23 as Ciphertext;
    add r15.value_ r23.value_ into r24;
    add r15.nonce r23.nonce into r25;
    cast r24 r25 into r26 as Ciphertext;
    add r1 r3 into r27;
    mul r0 r26.nonce into r28;
    cast r28 into r29 as field;
    mul r27 group::GEN into r30;
    sub r26.value_ r28 into r31;
    assert.eq r30 r31;


function test2:
    output -10_000scalar as scalar.private;
