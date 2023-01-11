pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__aide.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__aide.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E075 : Short_Integer; pragma Import (Ada, E075, "system__os_lib_E");
   E005 : Short_Integer; pragma Import (Ada, E005, "ada__exceptions_E");
   E011 : Short_Integer; pragma Import (Ada, E011, "system__soft_links_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exception_table_E");
   E038 : Short_Integer; pragma Import (Ada, E038, "ada__containers_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__io_exceptions_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__strings_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__strings__maps_E");
   E059 : Short_Integer; pragma Import (Ada, E059, "ada__strings__maps__constants_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "ada__tags_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "ada__streams_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "gnat_E");
   E043 : Short_Integer; pragma Import (Ada, E043, "interfaces__c_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exceptions_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "system__finalization_root_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "ada__finalization_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "system__storage_pools_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "system__checked_pools_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "gnat__debug_pools_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "system__object_reader_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "system__dwarf_lines_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__soft_links__initialize_E");
   E037 : Short_Integer; pragma Import (Ada, E037, "system__traceback__symbolic_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "gnatcoll__memory_E");
   E226 : Short_Integer; pragma Import (Ada, E226, "interfaces__c__strings_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "system__file_control_block_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "system__file_io_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "system__finalization_masters_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "system__storage_pools__subpools_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "ada__strings__unbounded_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "system__regpat_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "ada__calendar_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "ada__calendar__time_zones_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "ada__text_io_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "gnat__directory_operations_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "system__pool_global_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "gnat__expect_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "system__regexp_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "ada__directories_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "gnat__command_line_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "v20_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "v20__vst_E");
   E230 : Short_Integer; pragma Import (Ada, E230, "v20__fls_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "v20__prg_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "v20__sys_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "v20__tio_E");
   E228 : Short_Integer; pragma Import (Ada, E228, "v20__log_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E228 := E228 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "v20__log__finalize_spec");
      begin
         F1;
      end;
      E220 := E220 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "v20__prg__finalize_spec");
      begin
         F2;
      end;
      E200 := E200 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "ada__directories__finalize_spec");
      begin
         F3;
      end;
      E195 := E195 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__regexp__finalize_spec");
      begin
         F4;
      end;
      E250 := E250 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "gnat__expect__finalize_spec");
      begin
         F5;
      end;
      E157 := E157 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__pool_global__finalize_spec");
      begin
         F6;
      end;
      E143 := E143 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "ada__text_io__finalize_spec");
      begin
         F7;
      end;
      E110 := E110 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "ada__strings__unbounded__finalize_spec");
      begin
         F8;
      end;
      E118 := E118 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "system__storage_pools__subpools__finalize_spec");
      begin
         F9;
      end;
      E120 := E120 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "system__finalization_masters__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "system__file_io__finalize_body");
      begin
         E147 := E147 - 1;
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "gnatcoll__memory__finalize_body");
      begin
         E162 := E162 - 1;
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "gnat__debug_pools__finalize_body");
      begin
         E164 := E164 - 1;
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "gnat__debug_pools__finalize_spec");
      begin
         F14;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Exception_Tracebacks : Integer;
      pragma Import (C, Exception_Tracebacks, "__gl_exception_tracebacks");
      Exception_Tracebacks_Symbolic : Integer;
      pragma Import (C, Exception_Tracebacks_Symbolic, "__gl_exception_tracebacks_symbolic");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := '8';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Exception_Tracebacks := 1;
      Exception_Tracebacks_Symbolic := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      System.Scalar_Values.Initialize ('I', 'N');

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E023 := E023 + 1;
      Ada.Containers'Elab_Spec;
      E038 := E038 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E068 := E068 + 1;
      Ada.Strings'Elab_Spec;
      E053 := E053 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E055 := E055 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E059 := E059 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E101 := E101 + 1;
      Ada.Streams'Elab_Spec;
      E125 := E125 + 1;
      Gnat'Elab_Spec;
      E106 := E106 + 1;
      Interfaces.C'Elab_Spec;
      E043 := E043 + 1;
      System.Exceptions'Elab_Spec;
      E025 := E025 + 1;
      System.Finalization_Root'Elab_Spec;
      E127 := E127 + 1;
      Ada.Finalization'Elab_Spec;
      E123 := E123 + 1;
      System.Storage_Pools'Elab_Spec;
      E129 := E129 + 1;
      System.Checked_Pools'Elab_Spec;
      E186 := E186 + 1;
      Gnat.Debug_Pools'Elab_Spec;
      System.Object_Reader'Elab_Spec;
      E081 := E081 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E048 := E048 + 1;
      System.Os_Lib'Elab_Body;
      E075 := E075 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E019 := E019 + 1;
      E011 := E011 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E037 := E037 + 1;
      E005 := E005 + 1;
      Gnat.Debug_Pools'Elab_Body;
      E164 := E164 + 1;
      GNATCOLL.MEMORY'ELAB_BODY;
      E162 := E162 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E226 := E226 + 1;
      System.File_Control_Block'Elab_Spec;
      E148 := E148 + 1;
      System.File_Io'Elab_Body;
      E147 := E147 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E120 := E120 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E118 := E118 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E110 := E110 + 1;
      System.Regpat'Elab_Spec;
      E253 := E253 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E202 := E202 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E208 := E208 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E143 := E143 + 1;
      Gnat.Directory_Operations'Elab_Spec;
      Gnat.Directory_Operations'Elab_Body;
      E150 := E150 + 1;
      System.Pool_Global'Elab_Spec;
      E157 := E157 + 1;
      Gnat.Expect'Elab_Spec;
      E250 := E250 + 1;
      System.Regexp'Elab_Spec;
      E195 := E195 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E200 := E200 + 1;
      Gnat.Command_Line'Elab_Spec;
      Gnat.Command_Line'Elab_Body;
      E108 := E108 + 1;
      E248 := E248 + 1;
      v20.prg'elab_spec;
      E220 := E220 + 1;
      E232 := E232 + 1;
      E198 := E198 + 1;
      v20.log'elab_spec;
      E228 := E228 + 1;
      E230 := E230 + 1;
      E222 := E222 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_aide");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/gnatcoll.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/s-memory.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/gnatcoll-memory.o
   --   /home/sr/opt/gnat-2020/lib/gcc/x86_64-pc-linux-gnu/9.3.1/rts-native-debug/adalib/a-calend.o
   --   /home/sr/opt/gnat-2020/lib/gcc/x86_64-pc-linux-gnu/9.3.1/rts-native-debug/adalib/a-catizo.o
   --   /home/sr/opt/gnat-2020/lib/gcc/x86_64-pc-linux-gnu/9.3.1/rts-native-debug/adalib/a-calfor.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20-vst.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20-prg.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20-tio.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20-log.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20-fls.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/v20-sys.o
   --   /home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/aide.o
   --   -L/home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/
   --   -L/home/sr/Seafile/Sowebio/informatique/github/aide/obj/debug/
   --   -L/home/sr/opt/gnat-2020/lib/gcc/x86_64-pc-linux-gnu/9.3.1/rts-native-debug/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;
