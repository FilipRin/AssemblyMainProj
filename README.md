# AssemblyMainProj
C++ function that has struct Request as argument in assembly code : void process(int* arr1, int n, Request* r)
---------------------------------------------------------------------------------
ENG
- *SETUP* -
Place the main program from address 4000h. Initialize IV table and IVTP register according to
to the following table (the Device column contains the label of the device to which the input belongs):

Input number/ Content/ Device
  
    3       0500h     KP1.1
    4       1000h     KP1.2
    1       1500h     KP2.1
    0       2000h     DMA1.1
    2       2500h     DMA1.2
    5       3000h     DMA1.4
    IVTP = 0300h
 It is necessary to load arrays A and B and place them in memory starting at addresses 5000h and 6000h,
respectively. Both arrays have 8h elements each. String A load with KP1.1 using the interrupt mechanism,
and string B to load with KP2.1 using the interrupt mechanism. Load simultaneously with both
the periphery.

- *MAIN PART*
- Write a subroutine void process(int* arr1, int n, Request* r) which is in sequence
of length n pointed to by arr1 finds the smallest or largest element based on the value of the field
operation in the structure pointed to by r. The value 0 of the operation field means that the smallest, a, is sought
a value of 1 to search for the largest element. The found element should be placed in the structure element field
to which r points. After receiving strings A and B, it is necessary to call the subroutine process for both strings,
the structures for these two calls are located in memory at addresses 9996h and 9998h, respectively. The structure is
defined as struct Request { int operation; int element; }.
- *THIRD PART* -
After completing part B of the task, send string A to the peripheral KP1.2 by checking ready bit from status register.
Send value from memory location 9999h to device DMA1.2 in burst mode.

SRB
- *POSTAVKA* -
Glavni program smestiti od adrese 4000h. Inicijalizovati IV tabelu i IVTP registar prema
sledećoj tabeli (kolona Uređaj sadrži oznaku uređaja kome pripada ulaz):

Broj ulaza/   Sadržaj/   Uređaj
  
    3        0500h     KP1.1
    4        1000h     KP1.2
    1        1500h     KP2.1
    0        2000h     DMA1.1
    2        2500h     DMA1.2
    5        3000h     DMA1.4
    IVTP = 0300h
 Potrebno je učitati nizove A i B i smestiti ih u memoriju počevši od adresa 5000h i 6000h,
respektivno. Oba niza imaju po 8h elemenata. Niz A učitati sa KP1.1 korišćenjem mehanizma prekida,
a niz B učitati sa KP2.1 korišćenjem mehanizma prekida. Učitavanje obaviti uporedo sa obe
periferije.

- *GLAVNI DEO*
- Napisati potprogram void process(int* arr1, int n, Request* r) koja u nizu
dužine n na koji pokazuje arr1 pronalazi najmanji ili najveći element na osnovu vrednosti polja
operation u strukturi na koju pokazuje r. Vrednost 0 polja operation znači da se traži najmanji, a
vrednost 1 da se traži najveći element. Pronađeni element treba smestiti u polje element strukture
na koju pokazuje r. Nakon prijema nizova A i B potrebno je pozvati potprogram process za oba niza,
strukture za ova dva poziva se nalaze u memoriji na adresama 9996h i 9998h, respektivno. Struktura je
definisana kao struct Request { int operation; int element; }.
- *KRAJ* -
Nakon završenog dela B zadatka, niz A poslati periferiji KP1.2 ispitivanjem bita spremnosti.
Vrednost sa memorijske lokacije 9999h poslati uređaju DMA1.2 u paketskom režimu radu.
