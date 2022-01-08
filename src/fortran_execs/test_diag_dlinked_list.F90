!***********************************************************************
!*                   GNU Lesser General Public License
!*
!* This file is part of the GFDL Flexible Modeling System (FMS).
!*
!* FMS is free software: you can redistribute it and/or modify it under
!* the terms of the GNU Lesser General Public License as published by
!* the Free Software Foundation, either version 3 of the License, or (at
!* your option) any later version.
!*
!* FMS is distributed in the hope that it will be useful, but WITHOUT
!* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
!* for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with FMS.  If not, see <http://www.gnu.org/licenses/>.
!***********************************************************************

!! <TT>fms_diag_dlinked_list_mod</TT>  defines a generic doubly linked
!! list class  and an associated iterator class  for traversing the list. It
!! is generic in the sense that the elements or objects it contains are
!! "class(*)" objects. Note the public interface functions and the lack
!! of a search (or find) function as per the definition of a linked list.
!! If a search function, additional type cheeking,  or possibly a
!! slightly different user interface is desired, then consider creating
!! another iterator and another wrapper, or another class with this one for
!! a member element and procedures that are trivially implemented by using
!! this class. (See, for example, class FmsDiagObjectContainer_t and its
!! associated iterator.
!!
!! This version is roughly a Fortran translation of the C++ doubly linked list
!! class in the book ``Data Structures And Algorithm Analysis in C++",
!! 3rd Edition, by Mark Allen Weiss.
program test_diag_dlinked_list

   !! use fms_mod, ONLY: error_mesg, FATAL,NOTE

   use fms_diag_dlinked_list_mod, only : FmsDlList_t, FmsDllIterator_t

   implicit  none

   !> @brief  This class is the type for the data to insert in the linked list.
   type TestDummy_t
      integer :: id  = 0
      integer :: name = 100
   end type TestDummy_t

   !!
   type (FmsDlList_t), allocatable :: list !< Instance of the linked list
   class(FmsDllIterator_t), allocatable :: iter !< An iterator for the list
   type (TestDummy_t), pointer::   p_td_obj=>null()     !< A pointer to a test_dummy object
   class(*), pointer :: p_obj   => null()                !< A pointer to a class(*) object
   integer, parameter :: num_objs = 40          !< Total number of objects tested
   integer ::  full_id_sum                      !< Sum of all the possible object id values
   integer :: sum                               !< Temp sum of vaalues of id sets
   !!
   integer :: ierr                              !< An error flag
   logical :: test_passed                       !< Flag indicating if the test_passed
   !! These fields below used to initialize diag object data. TBD
   integer :: id
   ! character(:), allocatable :: mname, mname_pre

   integer:: FATAL, NOTE
   !!
   FATAL = 1
   NOTE = 0

   
   call error_mesg_mine("test_diag_linked_list", "Starting tests",NOTE)

   test_passed = .true.  !! will be set to false if there are any issues.

   !! Ids will initially be from 1 to num_objs, so :
   full_id_sum = (num_objs * (num_objs + 1)) / 2

   !!Create the list
   list = FmsDlList_t()

   if( list%size() /= 0) then
      test_passed = .false.
      call error_mesg_mine("test_diag_linked_list", "list incorrect size. Expected 0 at start",FATAL)
   endif
   !mname_pre = "ATM"

  !! Initialize num_objs objects and insert into list one at a time.
  !! The loop iterator is same as id - created in order to facilitate
   !! some tests.
   do id = 1, num_objs
      !!Allocate on heap another test dummy object :
      allocate (p_td_obj)
      !! And set some of its dummy data :
      !call combine_str_int(mname_pre, id, mname)
      p_td_obj%id = id
      p_td_obj%name = 1000 + id
      !! And have the "Char(*) pointer also point to it:
      p_obj => p_td_obj

      !! Test insertion the common way :
      iter = list%push_back( p_obj)
      if(iter%has_data() .eqv. .false. ) then
         test_passed = .false.
         call error_mesg_mine("test_diag_linked_list", "List push_back error.",FATAL)
      endif

   enddo

   if( list%size() /= num_objs) then
      test_passed = .false.
      call error_mesg_mine("test_diag_linked_list", "List has incorrect size after inserts.",FATAL)
   endif

   call error_mesg_mine("test_diag_linked_list", "Finished tests",NOTE)
   

 CONTAINS

   subroutine error_mesg_mine(ma, mb , stat)
      character(*),  intent (in) :: ma
      character(*),  intent (in) :: mb
      integer, intent (in) :: stat
   IF(stat == NOTE) then
      print *, ma, " ", mb, " *** NOTE *** "
   else 
      print *, ma, " ", mb, " *** ERROR ***"
      stop 1
   end if
     end subroutine error_mesg_mine
   

   

end program test_diag_dlinked_list


