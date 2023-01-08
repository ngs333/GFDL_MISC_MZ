PROGRAM  test_elemental_weighting_procs

   IMPLICIT NONE
   INTEGER, PARAMETER :: SZ=10
   REAL, DIMENSION(:,:,:), ALLOCATABLE :: field !< The latest field data user is sending.
   REAL, DIMENSION(:,:,:,:), ALLOCATABLE :: ofb !< Output Field Buffer  
   REAL, DIMENSION(:,:,:,:), ALLOCATABLE :: ofb2
   LOGICAL, DIMENSION(:,:,:), ALLOCATABLE :: mask
   REAL :: weight1 = 2.0
   INTEGER  :: pow_value = 2.0
   INTEGER, DIMENSION(3) :: l_start !< local start indices on 3 axes for regional output
   INTEGER, DIMENSION(3) :: l_end !< local end indices on 3 axes for regional output
   INTEGER :: is, js, ks
   INTEGER :: ie, je, ke
   INTEGER :: hi, hj !<Halo size in x and y direction
   INTEGER :: f1, f2, f3, f4

   INTEGER i

   ALLOCATE(field(SZ,SZ,SZ))
   ALLOCATE(ofb(SZ,SZ,SZ,2))
   ALLOCATE(ofb2(SZ,SZ,SZ,2))
   ALLOCATE(mask(SZ,SZ,SZ))
   field  = 1.0
   ofb(:,:,:,1) = 0.0
   ofb2(:,:,:,1) = 0.0
   mask = .true.
   mask(1:SZ:2,:,:) = .false. !!even rows are .false.
   is = 1
   js = 1
   ks = 1
   ie = SZ
   je = SZ
   ke = SZ
   hi = 0
   hj = 0

   l_start = 1
   l_end = SZ
   f1 = 1
   f2 = SZ
   f3 = 1
   f4 = SZ

   call AVERAGE_THE_FIELD(field, ofb, ofb2, mask, weight1, pow_value, l_start, l_end, is, js, ks, &
      ie, je, ke, hi, hj, f1, f2, f3, f4)

CONTAINS
   
   ELEMENTAL SUBROUTINE weight_the_elem( buff, field, weight, pow_value)
      REAL, INTENT(INOUT) :: buff
      REAL, INTENT(IN) :: field
      REAL, INTENT(IN) :: weight
      INTEGER, INTENT(IN) :: pow_value

      buff = buff + (field * weight) ** pow_value
   END SUBROUTINE weight_the_elem

   ELEMENTAL SUBROUTINE weight_the_elem_wm( buff, field, mask, weight, pow_value, missvalue )
      REAL, INTENT(INOUT) :: buff
      REAL, INTENT(IN) :: field
      LOGICAL, INTENT(IN) :: mask
      REAL, INTENT(IN) :: weight
      INTEGER, INTENT(IN) :: pow_value
      REAL, INTENT(IN) :: missvalue

      if (mask .eqv. .true.) THEN
         buff = buff + (field * weight) ** pow_value
      ELSE
         buff = missvalue
      END IF
   END SUBROUTINE weight_the_elem_wm

   SUBROUTINE AVERAGE_THE_FIELD(field, ofb, ofb2, mask, weight1, pow_value, &
   & l_start, l_end, is, js, ks, ie, ke, je, &
   & hi, hj, f1, f2, f3, f4)
      REAL, DIMENSION(:,:,:), INTENT(in) :: field !< The latest field data user is sending.
      REAL, allocatable, DIMENSION(:,:,:,:), INTENT(inout) :: ofb, ofb2 !< Output Field Buffers  
      LOGICAL, DIMENSION(:,:,:), INTENT(in):: mask
      REAL, INTENT(in) :: weight1
      INTEGER , INTENT(in) :: pow_value
      INTEGER, DIMENSION(3), INTENT(in)  :: l_start !< local start indices on 3 axes for regional output
      INTEGER, DIMENSION(3), INTENT(in)  :: l_end !< local end indices on 3 axes for regional output
      INTEGER, INTENT(in)  :: is, js, ks, ie, je, ke
      INTEGER, INTENT(in)  :: hi, hj !<Halo size in x and y direction
      INTEGER, INTENT(in)  :: f1, f2, f3, f4
    
      INTEGER :: ksr, ker
      INTEGER :: i, j, k,  i1, j1, k1

      INTEGER :: sample = 1  !< index along the diurnal time axis
      REAL :: missvalue = 2.0e-10

      REAL :: itemp = 2

      !!CASE 1 - original loop :
      ksr= l_start(3)
      ker= l_end(3)
      ofb(is-hi:ie-hi,js-hj:je-hj,:,sample) =  ofb(is-hi:ie-hi,js-hj:je-hj,:,sample) + &
      & (field(f1:f2,f3:f4,ksr:ker) * weight1) ** pow_value

      !!CASE 1 - using elemental procedure :
      call weight_the_elem(ofb2(is-hi:ie-hi,js-hj:je-hj,:,sample), &
         & field(f1:f2,f3:f4,ksr:ker), weight1, pow_value)

      IF (ALL (ofb /= ofb2)) THEN
         print *, "ERROR: ofb /= ofb2 CASE1"
      ELSE
         print *, "OK: ofb == ofb2 in CASE1"
      END IF

      ofb2(:,:,:,1) = 0.0
      !! CASE 2 - original loop :
      DO k=ks, ke
         DO j=js, je
            DO i=is, ie
               IF ( mask(i-is+1+hi,j-js+1+hj,k) ) THEN
                  ofb(i-hi,j-hj,k,sample) = ofb(i-hi,j-hj,k,sample) + &
                  & ( field(i-is+1+hi,j-js+1+hj,k) * weight1) ** pow_value
               ELSE
                  ofb(i-hi,j-hj,k,sample)= missvalue
               END IF
            END DO
         END DO
      END DO

      ofb2(:,:,:,1) = 0.0
      !! CASE 2.A - using elemental procedure :
      DO k=ks, ke
         DO j=js, je
            DO i=is, ie
               IF ( mask(i-is+1+hi,j-js+1+hj,k) ) THEN
                  call weight_the_elem(ofb(i-hi,j-hj,k,sample), &
                  & field(i-is+1+hi,j-js+1+hj,k), weight1, pow_value)
               ELSE
                  ofb(i-hi,j-hj,k,sample)= missvalue
               END IF
            END DO
         END DO
      END DO
      IF (ALL (ofb /= ofb2)) THEN
         print *, "ERROR: ofb /= ofb2 CASE2.A"
      ELSE
         print *, "OK: ofb == ofb2 in CASE2.A"
      END IF

      ofb2(:,:,:,1) = 0.0
      !! CASE 2.B - using elemental procedure with mask - shorter version B :
         DO j=js, je
            DO i=is, ie
                  call weight_the_elem_wm(ofb(i-hi,j-hj,:,sample), &
                  & field(i-is+1+hi,j-js+1+hj,:), mask(i-is+1+hi,j-js+1+hj,:),  &
                  & weight1, pow_value, missvalue)
            END DO
         END DO
      IF (ALL (ofb /= ofb2)) THEN
         print *, "ERROR: ofb /= ofb2 CASE2.B"
      ELSE
         print *, "OK: ofb == ofb2 in CASE2.B"
      END IF

       !! CASE 2.C - using elemental procedure - even shorter version C :

      

      RETURN

   END SUBROUTINE AVERAGE_THE_FIELD

END PROGRAM test_elemental_weighting_procs


