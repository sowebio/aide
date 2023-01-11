pragma Warnings (Off);
pragma Ada_95;
with System;
with System.Scalar_Values;
with System.Parameters;
with System.Secondary_Stack;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: Community 2020 (20200429-93)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_aide" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#1b4bf69b#;
   pragma Export (C, u00001, "aideB");
   u00002 : constant Version_32 := 16#67c8d842#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#23d4d899#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#f435a12e#;
   pragma Export (C, u00004, "ada__exceptionsB");
   u00005 : constant Version_32 := 16#bb2e31f9#;
   pragma Export (C, u00005, "ada__exceptionsS");
   u00006 : constant Version_32 := 16#76789da1#;
   pragma Export (C, u00006, "adaS");
   u00007 : constant Version_32 := 16#35e1815f#;
   pragma Export (C, u00007, "ada__exceptions__last_chance_handlerB");
   u00008 : constant Version_32 := 16#cfec26ee#;
   pragma Export (C, u00008, "ada__exceptions__last_chance_handlerS");
   u00009 : constant Version_32 := 16#4635ec04#;
   pragma Export (C, u00009, "systemS");
   u00010 : constant Version_32 := 16#ae860117#;
   pragma Export (C, u00010, "system__soft_linksB");
   u00011 : constant Version_32 := 16#39005bef#;
   pragma Export (C, u00011, "system__soft_linksS");
   u00012 : constant Version_32 := 16#2d437d19#;
   pragma Export (C, u00012, "system__secondary_stackB");
   u00013 : constant Version_32 := 16#b79edb80#;
   pragma Export (C, u00013, "system__secondary_stackS");
   u00014 : constant Version_32 := 16#896564a3#;
   pragma Export (C, u00014, "system__parametersB");
   u00015 : constant Version_32 := 16#016728cf#;
   pragma Export (C, u00015, "system__parametersS");
   u00016 : constant Version_32 := 16#ced09590#;
   pragma Export (C, u00016, "system__storage_elementsB");
   u00017 : constant Version_32 := 16#6bf6a600#;
   pragma Export (C, u00017, "system__storage_elementsS");
   u00018 : constant Version_32 := 16#ce3e0e21#;
   pragma Export (C, u00018, "system__soft_links__initializeB");
   u00019 : constant Version_32 := 16#5697fc2b#;
   pragma Export (C, u00019, "system__soft_links__initializeS");
   u00020 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00020, "system__stack_checkingB");
   u00021 : constant Version_32 := 16#c88a87ec#;
   pragma Export (C, u00021, "system__stack_checkingS");
   u00022 : constant Version_32 := 16#34742901#;
   pragma Export (C, u00022, "system__exception_tableB");
   u00023 : constant Version_32 := 16#795caff4#;
   pragma Export (C, u00023, "system__exception_tableS");
   u00024 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00024, "system__exceptionsB");
   u00025 : constant Version_32 := 16#2e5681f2#;
   pragma Export (C, u00025, "system__exceptionsS");
   u00026 : constant Version_32 := 16#69416224#;
   pragma Export (C, u00026, "system__exceptions__machineB");
   u00027 : constant Version_32 := 16#5c74e542#;
   pragma Export (C, u00027, "system__exceptions__machineS");
   u00028 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00028, "system__exceptions_debugB");
   u00029 : constant Version_32 := 16#5a783f72#;
   pragma Export (C, u00029, "system__exceptions_debugS");
   u00030 : constant Version_32 := 16#6c2f8802#;
   pragma Export (C, u00030, "system__img_intB");
   u00031 : constant Version_32 := 16#44ee0cc6#;
   pragma Export (C, u00031, "system__img_intS");
   u00032 : constant Version_32 := 16#39df8c17#;
   pragma Export (C, u00032, "system__tracebackB");
   u00033 : constant Version_32 := 16#181732c0#;
   pragma Export (C, u00033, "system__tracebackS");
   u00034 : constant Version_32 := 16#9ed49525#;
   pragma Export (C, u00034, "system__traceback_entriesB");
   u00035 : constant Version_32 := 16#466e1a74#;
   pragma Export (C, u00035, "system__traceback_entriesS");
   u00036 : constant Version_32 := 16#e162df04#;
   pragma Export (C, u00036, "system__traceback__symbolicB");
   u00037 : constant Version_32 := 16#46491211#;
   pragma Export (C, u00037, "system__traceback__symbolicS");
   u00038 : constant Version_32 := 16#179d7d28#;
   pragma Export (C, u00038, "ada__containersS");
   u00039 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00039, "ada__exceptions__tracebackB");
   u00040 : constant Version_32 := 16#ae2d2db5#;
   pragma Export (C, u00040, "ada__exceptions__tracebackS");
   u00041 : constant Version_32 := 16#5ab55268#;
   pragma Export (C, u00041, "interfacesS");
   u00042 : constant Version_32 := 16#e49bce3e#;
   pragma Export (C, u00042, "interfaces__cB");
   u00043 : constant Version_32 := 16#dbc36ce0#;
   pragma Export (C, u00043, "interfaces__cS");
   u00044 : constant Version_32 := 16#e865e681#;
   pragma Export (C, u00044, "system__bounded_stringsB");
   u00045 : constant Version_32 := 16#31c8cd1d#;
   pragma Export (C, u00045, "system__bounded_stringsS");
   u00046 : constant Version_32 := 16#0fdcf3be#;
   pragma Export (C, u00046, "system__crtlS");
   u00047 : constant Version_32 := 16#108b4f79#;
   pragma Export (C, u00047, "system__dwarf_linesB");
   u00048 : constant Version_32 := 16#345b739f#;
   pragma Export (C, u00048, "system__dwarf_linesS");
   u00049 : constant Version_32 := 16#5b4659fa#;
   pragma Export (C, u00049, "ada__charactersS");
   u00050 : constant Version_32 := 16#8f637df8#;
   pragma Export (C, u00050, "ada__characters__handlingB");
   u00051 : constant Version_32 := 16#3b3f6154#;
   pragma Export (C, u00051, "ada__characters__handlingS");
   u00052 : constant Version_32 := 16#4b7bb96a#;
   pragma Export (C, u00052, "ada__characters__latin_1S");
   u00053 : constant Version_32 := 16#e6d4fa36#;
   pragma Export (C, u00053, "ada__stringsS");
   u00054 : constant Version_32 := 16#96df1a3f#;
   pragma Export (C, u00054, "ada__strings__mapsB");
   u00055 : constant Version_32 := 16#1e526bec#;
   pragma Export (C, u00055, "ada__strings__mapsS");
   u00056 : constant Version_32 := 16#32cfc5a0#;
   pragma Export (C, u00056, "system__bit_opsB");
   u00057 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00057, "system__bit_opsS");
   u00058 : constant Version_32 := 16#18fa9e16#;
   pragma Export (C, u00058, "system__unsigned_typesS");
   u00059 : constant Version_32 := 16#92f05f13#;
   pragma Export (C, u00059, "ada__strings__maps__constantsS");
   u00060 : constant Version_32 := 16#a0d3d22b#;
   pragma Export (C, u00060, "system__address_imageB");
   u00061 : constant Version_32 := 16#e7d9713e#;
   pragma Export (C, u00061, "system__address_imageS");
   u00062 : constant Version_32 := 16#8631cc2e#;
   pragma Export (C, u00062, "system__img_unsB");
   u00063 : constant Version_32 := 16#870ea2e1#;
   pragma Export (C, u00063, "system__img_unsS");
   u00064 : constant Version_32 := 16#20ec7aa3#;
   pragma Export (C, u00064, "system__ioB");
   u00065 : constant Version_32 := 16#d8771b4b#;
   pragma Export (C, u00065, "system__ioS");
   u00066 : constant Version_32 := 16#f790d1ef#;
   pragma Export (C, u00066, "system__mmapB");
   u00067 : constant Version_32 := 16#ee41b8bb#;
   pragma Export (C, u00067, "system__mmapS");
   u00068 : constant Version_32 := 16#92d882c5#;
   pragma Export (C, u00068, "ada__io_exceptionsS");
   u00069 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00069, "system__concat_2B");
   u00070 : constant Version_32 := 16#44953bd4#;
   pragma Export (C, u00070, "system__concat_2S");
   u00071 : constant Version_32 := 16#91eaca2e#;
   pragma Export (C, u00071, "system__mmap__os_interfaceB");
   u00072 : constant Version_32 := 16#1fc2f713#;
   pragma Export (C, u00072, "system__mmap__os_interfaceS");
   u00073 : constant Version_32 := 16#8c787ae2#;
   pragma Export (C, u00073, "system__mmap__unixS");
   u00074 : constant Version_32 := 16#11eb9166#;
   pragma Export (C, u00074, "system__os_libB");
   u00075 : constant Version_32 := 16#d872da39#;
   pragma Export (C, u00075, "system__os_libS");
   u00076 : constant Version_32 := 16#ec4d5631#;
   pragma Export (C, u00076, "system__case_utilB");
   u00077 : constant Version_32 := 16#79e05a50#;
   pragma Export (C, u00077, "system__case_utilS");
   u00078 : constant Version_32 := 16#2a8e89ad#;
   pragma Export (C, u00078, "system__stringsB");
   u00079 : constant Version_32 := 16#2623c091#;
   pragma Export (C, u00079, "system__stringsS");
   u00080 : constant Version_32 := 16#c83ab8ef#;
   pragma Export (C, u00080, "system__object_readerB");
   u00081 : constant Version_32 := 16#82413105#;
   pragma Export (C, u00081, "system__object_readerS");
   u00082 : constant Version_32 := 16#914b0305#;
   pragma Export (C, u00082, "system__val_lliB");
   u00083 : constant Version_32 := 16#2a5b7ef4#;
   pragma Export (C, u00083, "system__val_lliS");
   u00084 : constant Version_32 := 16#d2ae2792#;
   pragma Export (C, u00084, "system__val_lluB");
   u00085 : constant Version_32 := 16#753413f4#;
   pragma Export (C, u00085, "system__val_lluS");
   u00086 : constant Version_32 := 16#269742a9#;
   pragma Export (C, u00086, "system__val_utilB");
   u00087 : constant Version_32 := 16#ea955afa#;
   pragma Export (C, u00087, "system__val_utilS");
   u00088 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00088, "system__concat_3B");
   u00089 : constant Version_32 := 16#4d45b0a1#;
   pragma Export (C, u00089, "system__concat_3S");
   u00090 : constant Version_32 := 16#b578159b#;
   pragma Export (C, u00090, "system__exception_tracesB");
   u00091 : constant Version_32 := 16#62eacc9e#;
   pragma Export (C, u00091, "system__exception_tracesS");
   u00092 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00092, "system__wch_conB");
   u00093 : constant Version_32 := 16#5d48ced6#;
   pragma Export (C, u00093, "system__wch_conS");
   u00094 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00094, "system__wch_stwB");
   u00095 : constant Version_32 := 16#7059e2d7#;
   pragma Export (C, u00095, "system__wch_stwS");
   u00096 : constant Version_32 := 16#a831679c#;
   pragma Export (C, u00096, "system__wch_cnvB");
   u00097 : constant Version_32 := 16#52ff7425#;
   pragma Export (C, u00097, "system__wch_cnvS");
   u00098 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00098, "system__wch_jisB");
   u00099 : constant Version_32 := 16#d28f6d04#;
   pragma Export (C, u00099, "system__wch_jisS");
   u00100 : constant Version_32 := 16#f9576a72#;
   pragma Export (C, u00100, "ada__tagsB");
   u00101 : constant Version_32 := 16#b6661f55#;
   pragma Export (C, u00101, "ada__tagsS");
   u00102 : constant Version_32 := 16#796f31f1#;
   pragma Export (C, u00102, "system__htableB");
   u00103 : constant Version_32 := 16#c2f75fee#;
   pragma Export (C, u00103, "system__htableS");
   u00104 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00104, "system__string_hashB");
   u00105 : constant Version_32 := 16#60a93490#;
   pragma Export (C, u00105, "system__string_hashS");
   u00106 : constant Version_32 := 16#b5988c27#;
   pragma Export (C, u00106, "gnatS");
   u00107 : constant Version_32 := 16#ce2c93e9#;
   pragma Export (C, u00107, "gnat__command_lineB");
   u00108 : constant Version_32 := 16#0b5ceadc#;
   pragma Export (C, u00108, "gnat__command_lineS");
   u00109 : constant Version_32 := 16#c6ca4532#;
   pragma Export (C, u00109, "ada__strings__unboundedB");
   u00110 : constant Version_32 := 16#6552cb60#;
   pragma Export (C, u00110, "ada__strings__unboundedS");
   u00111 : constant Version_32 := 16#60da0992#;
   pragma Export (C, u00111, "ada__strings__searchB");
   u00112 : constant Version_32 := 16#c1ab8667#;
   pragma Export (C, u00112, "ada__strings__searchS");
   u00113 : constant Version_32 := 16#acee74ad#;
   pragma Export (C, u00113, "system__compare_array_unsigned_8B");
   u00114 : constant Version_32 := 16#ef369d89#;
   pragma Export (C, u00114, "system__compare_array_unsigned_8S");
   u00115 : constant Version_32 := 16#a8025f3c#;
   pragma Export (C, u00115, "system__address_operationsB");
   u00116 : constant Version_32 := 16#55395237#;
   pragma Export (C, u00116, "system__address_operationsS");
   u00117 : constant Version_32 := 16#d5d8c501#;
   pragma Export (C, u00117, "system__storage_pools__subpoolsB");
   u00118 : constant Version_32 := 16#e136d7bf#;
   pragma Export (C, u00118, "system__storage_pools__subpoolsS");
   u00119 : constant Version_32 := 16#57674f80#;
   pragma Export (C, u00119, "system__finalization_mastersB");
   u00120 : constant Version_32 := 16#4552acd4#;
   pragma Export (C, u00120, "system__finalization_mastersS");
   u00121 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00121, "system__img_boolB");
   u00122 : constant Version_32 := 16#b3ec9def#;
   pragma Export (C, u00122, "system__img_boolS");
   u00123 : constant Version_32 := 16#86c56e5a#;
   pragma Export (C, u00123, "ada__finalizationS");
   u00124 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00124, "ada__streamsB");
   u00125 : constant Version_32 := 16#67e31212#;
   pragma Export (C, u00125, "ada__streamsS");
   u00126 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00126, "system__finalization_rootB");
   u00127 : constant Version_32 := 16#09c79f94#;
   pragma Export (C, u00127, "system__finalization_rootS");
   u00128 : constant Version_32 := 16#35d6ef80#;
   pragma Export (C, u00128, "system__storage_poolsB");
   u00129 : constant Version_32 := 16#3d430bb3#;
   pragma Export (C, u00129, "system__storage_poolsS");
   u00130 : constant Version_32 := 16#84042202#;
   pragma Export (C, u00130, "system__storage_pools__subpools__finalizationB");
   u00131 : constant Version_32 := 16#8bd8fdc9#;
   pragma Export (C, u00131, "system__storage_pools__subpools__finalizationS");
   u00132 : constant Version_32 := 16#020a3f4d#;
   pragma Export (C, u00132, "system__atomic_countersB");
   u00133 : constant Version_32 := 16#f269c189#;
   pragma Export (C, u00133, "system__atomic_countersS");
   u00134 : constant Version_32 := 16#5252521d#;
   pragma Export (C, u00134, "system__stream_attributesB");
   u00135 : constant Version_32 := 16#d573b948#;
   pragma Export (C, u00135, "system__stream_attributesS");
   u00136 : constant Version_32 := 16#3e25f63c#;
   pragma Export (C, u00136, "system__stream_attributes__xdrB");
   u00137 : constant Version_32 := 16#2f60cd1f#;
   pragma Export (C, u00137, "system__stream_attributes__xdrS");
   u00138 : constant Version_32 := 16#1e40f010#;
   pragma Export (C, u00138, "system__fat_fltS");
   u00139 : constant Version_32 := 16#3872f91d#;
   pragma Export (C, u00139, "system__fat_lfltS");
   u00140 : constant Version_32 := 16#42a257f7#;
   pragma Export (C, u00140, "system__fat_llfS");
   u00141 : constant Version_32 := 16#ed063051#;
   pragma Export (C, u00141, "system__fat_sfltS");
   u00142 : constant Version_32 := 16#f4e097a7#;
   pragma Export (C, u00142, "ada__text_ioB");
   u00143 : constant Version_32 := 16#777d5329#;
   pragma Export (C, u00143, "ada__text_ioS");
   u00144 : constant Version_32 := 16#73d2d764#;
   pragma Export (C, u00144, "interfaces__c_streamsB");
   u00145 : constant Version_32 := 16#b1330297#;
   pragma Export (C, u00145, "interfaces__c_streamsS");
   u00146 : constant Version_32 := 16#ec9c64c3#;
   pragma Export (C, u00146, "system__file_ioB");
   u00147 : constant Version_32 := 16#e1440d61#;
   pragma Export (C, u00147, "system__file_ioS");
   u00148 : constant Version_32 := 16#bbaa76ac#;
   pragma Export (C, u00148, "system__file_control_blockS");
   u00149 : constant Version_32 := 16#fb62c2c6#;
   pragma Export (C, u00149, "gnat__directory_operationsB");
   u00150 : constant Version_32 := 16#8f1a5551#;
   pragma Export (C, u00150, "gnat__directory_operationsS");
   u00151 : constant Version_32 := 16#97ae1e3d#;
   pragma Export (C, u00151, "ada__strings__fixedB");
   u00152 : constant Version_32 := 16#fec1aafc#;
   pragma Export (C, u00152, "ada__strings__fixedS");
   u00153 : constant Version_32 := 16#efb85c8a#;
   pragma Export (C, u00153, "gnat__os_libS");
   u00154 : constant Version_32 := 16#932a4690#;
   pragma Export (C, u00154, "system__concat_4B");
   u00155 : constant Version_32 := 16#3851c724#;
   pragma Export (C, u00155, "system__concat_4S");
   u00156 : constant Version_32 := 16#021224f8#;
   pragma Export (C, u00156, "system__pool_globalB");
   u00157 : constant Version_32 := 16#29da5924#;
   pragma Export (C, u00157, "system__pool_globalS");
   u00158 : constant Version_32 := 16#38046db6#;
   pragma Export (C, u00158, "system__memoryB");
   u00159 : constant Version_32 := 16#1f488a30#;
   pragma Export (C, u00159, "system__memoryS");
   u00160 : constant Version_32 := 16#6a5da479#;
   pragma Export (C, u00160, "gnatcollS");
   u00161 : constant Version_32 := 16#496e07c8#;
   pragma Export (C, u00161, "gnatcoll__memoryB");
   u00162 : constant Version_32 := 16#208dc4c5#;
   pragma Export (C, u00162, "gnatcoll__memoryS");
   u00163 : constant Version_32 := 16#3bd3a9b0#;
   pragma Export (C, u00163, "gnat__debug_poolsB");
   u00164 : constant Version_32 := 16#3ad8ef4b#;
   pragma Export (C, u00164, "gnat__debug_poolsS");
   u00165 : constant Version_32 := 16#9d926ccc#;
   pragma Export (C, u00165, "gnat__debug_utilitiesB");
   u00166 : constant Version_32 := 16#f0bcc798#;
   pragma Export (C, u00166, "gnat__debug_utilitiesS");
   u00167 : constant Version_32 := 16#be789e08#;
   pragma Export (C, u00167, "gnat__htableB");
   u00168 : constant Version_32 := 16#7a3e0440#;
   pragma Export (C, u00168, "gnat__htableS");
   u00169 : constant Version_32 := 16#8099c5e3#;
   pragma Export (C, u00169, "gnat__ioB");
   u00170 : constant Version_32 := 16#2a95b695#;
   pragma Export (C, u00170, "gnat__ioS");
   u00171 : constant Version_32 := 16#ea75efa1#;
   pragma Export (C, u00171, "gnat__tracebackB");
   u00172 : constant Version_32 := 16#ffed3214#;
   pragma Export (C, u00172, "gnat__tracebackS");
   u00173 : constant Version_32 := 16#608e2cd1#;
   pragma Export (C, u00173, "system__concat_5B");
   u00174 : constant Version_32 := 16#c16baf2a#;
   pragma Export (C, u00174, "system__concat_5S");
   u00175 : constant Version_32 := 16#a83b7c85#;
   pragma Export (C, u00175, "system__concat_6B");
   u00176 : constant Version_32 := 16#94f2c1b6#;
   pragma Export (C, u00176, "system__concat_6S");
   u00177 : constant Version_32 := 16#9dca6636#;
   pragma Export (C, u00177, "system__img_lliB");
   u00178 : constant Version_32 := 16#577ab9d5#;
   pragma Export (C, u00178, "system__img_lliS");
   u00179 : constant Version_32 := 16#54da27e6#;
   pragma Export (C, u00179, "system__img_lluB");
   u00180 : constant Version_32 := 16#51339ed5#;
   pragma Export (C, u00180, "system__img_lluS");
   u00181 : constant Version_32 := 16#8f828546#;
   pragma Export (C, u00181, "system__img_realB");
   u00182 : constant Version_32 := 16#d9ae7b96#;
   pragma Export (C, u00182, "system__img_realS");
   u00183 : constant Version_32 := 16#1b28662b#;
   pragma Export (C, u00183, "system__float_controlB");
   u00184 : constant Version_32 := 16#a6c9af38#;
   pragma Export (C, u00184, "system__float_controlS");
   u00185 : constant Version_32 := 16#16458a73#;
   pragma Export (C, u00185, "system__powten_tableS");
   u00186 : constant Version_32 := 16#f90dbcc5#;
   pragma Export (C, u00186, "system__checked_poolsS");
   u00187 : constant Version_32 := 16#65de8d35#;
   pragma Export (C, u00187, "system__val_intB");
   u00188 : constant Version_32 := 16#f3ca8567#;
   pragma Export (C, u00188, "system__val_intS");
   u00189 : constant Version_32 := 16#5276dcb7#;
   pragma Export (C, u00189, "system__val_unsB");
   u00190 : constant Version_32 := 16#2dfce3af#;
   pragma Export (C, u00190, "system__val_unsS");
   u00191 : constant Version_32 := 16#4fc9bc76#;
   pragma Export (C, u00191, "ada__command_lineB");
   u00192 : constant Version_32 := 16#3cdef8c9#;
   pragma Export (C, u00192, "ada__command_lineS");
   u00193 : constant Version_32 := 16#40fe4806#;
   pragma Export (C, u00193, "gnat__regexpS");
   u00194 : constant Version_32 := 16#95f86c43#;
   pragma Export (C, u00194, "system__regexpB");
   u00195 : constant Version_32 := 16#65074bc8#;
   pragma Export (C, u00195, "system__regexpS");
   u00196 : constant Version_32 := 16#fcd606d0#;
   pragma Export (C, u00196, "gnat__stringsS");
   u00197 : constant Version_32 := 16#0a7bb4f8#;
   pragma Export (C, u00197, "v20B");
   u00198 : constant Version_32 := 16#6f36a73b#;
   pragma Export (C, u00198, "v20S");
   u00199 : constant Version_32 := 16#c48efd12#;
   pragma Export (C, u00199, "ada__directoriesB");
   u00200 : constant Version_32 := 16#7b0ecd0f#;
   pragma Export (C, u00200, "ada__directoriesS");
   u00201 : constant Version_32 := 16#57c21ad4#;
   pragma Export (C, u00201, "ada__calendarB");
   u00202 : constant Version_32 := 16#31350a81#;
   pragma Export (C, u00202, "ada__calendarS");
   u00203 : constant Version_32 := 16#51f2d040#;
   pragma Export (C, u00203, "system__os_primitivesB");
   u00204 : constant Version_32 := 16#41c889f2#;
   pragma Export (C, u00204, "system__os_primitivesS");
   u00205 : constant Version_32 := 16#89410887#;
   pragma Export (C, u00205, "ada__calendar__formattingB");
   u00206 : constant Version_32 := 16#a2aff7a7#;
   pragma Export (C, u00206, "ada__calendar__formattingS");
   u00207 : constant Version_32 := 16#974d849e#;
   pragma Export (C, u00207, "ada__calendar__time_zonesB");
   u00208 : constant Version_32 := 16#ade8f076#;
   pragma Export (C, u00208, "ada__calendar__time_zonesS");
   u00209 : constant Version_32 := 16#406460f1#;
   pragma Export (C, u00209, "system__val_realB");
   u00210 : constant Version_32 := 16#484a00d1#;
   pragma Export (C, u00210, "system__val_realS");
   u00211 : constant Version_32 := 16#b2a569d2#;
   pragma Export (C, u00211, "system__exn_llfB");
   u00212 : constant Version_32 := 16#fa4b57d8#;
   pragma Export (C, u00212, "system__exn_llfS");
   u00213 : constant Version_32 := 16#99e097bd#;
   pragma Export (C, u00213, "ada__directories__hierarchical_file_namesB");
   u00214 : constant Version_32 := 16#752941c9#;
   pragma Export (C, u00214, "ada__directories__hierarchical_file_namesS");
   u00215 : constant Version_32 := 16#ab4ad33a#;
   pragma Export (C, u00215, "ada__directories__validityB");
   u00216 : constant Version_32 := 16#498b13d5#;
   pragma Export (C, u00216, "ada__directories__validityS");
   u00217 : constant Version_32 := 16#962faca4#;
   pragma Export (C, u00217, "system__file_attributesS");
   u00218 : constant Version_32 := 16#7fa4fe77#;
   pragma Export (C, u00218, "system__os_constantsS");
   u00219 : constant Version_32 := 16#e36415c5#;
   pragma Export (C, u00219, "v20__prgB");
   u00220 : constant Version_32 := 16#7aadcde9#;
   pragma Export (C, u00220, "v20__prgS");
   u00221 : constant Version_32 := 16#b5147aaa#;
   pragma Export (C, u00221, "v20__sysB");
   u00222 : constant Version_32 := 16#f5faedbd#;
   pragma Export (C, u00222, "v20__sysS");
   u00223 : constant Version_32 := 16#71641cad#;
   pragma Export (C, u00223, "ada__environment_variablesB");
   u00224 : constant Version_32 := 16#767099b7#;
   pragma Export (C, u00224, "ada__environment_variablesS");
   u00225 : constant Version_32 := 16#69f6ee6b#;
   pragma Export (C, u00225, "interfaces__c__stringsB");
   u00226 : constant Version_32 := 16#f239f79c#;
   pragma Export (C, u00226, "interfaces__c__stringsS");
   u00227 : constant Version_32 := 16#681f8190#;
   pragma Export (C, u00227, "v20__logB");
   u00228 : constant Version_32 := 16#05213dbd#;
   pragma Export (C, u00228, "v20__logS");
   u00229 : constant Version_32 := 16#66e868b5#;
   pragma Export (C, u00229, "v20__flsB");
   u00230 : constant Version_32 := 16#302d3ee4#;
   pragma Export (C, u00230, "v20__flsS");
   u00231 : constant Version_32 := 16#3a0abd42#;
   pragma Export (C, u00231, "v20__tioB");
   u00232 : constant Version_32 := 16#918cff12#;
   pragma Export (C, u00232, "v20__tioS");
   u00233 : constant Version_32 := 16#f64b89a4#;
   pragma Export (C, u00233, "ada__integer_text_ioB");
   u00234 : constant Version_32 := 16#2ec7c168#;
   pragma Export (C, u00234, "ada__integer_text_ioS");
   u00235 : constant Version_32 := 16#fdedfd10#;
   pragma Export (C, u00235, "ada__text_io__integer_auxB");
   u00236 : constant Version_32 := 16#2fe01d89#;
   pragma Export (C, u00236, "ada__text_io__integer_auxS");
   u00237 : constant Version_32 := 16#181dc502#;
   pragma Export (C, u00237, "ada__text_io__generic_auxB");
   u00238 : constant Version_32 := 16#305a076a#;
   pragma Export (C, u00238, "ada__text_io__generic_auxS");
   u00239 : constant Version_32 := 16#db42ae56#;
   pragma Export (C, u00239, "system__img_biuB");
   u00240 : constant Version_32 := 16#ded8165b#;
   pragma Export (C, u00240, "system__img_biuS");
   u00241 : constant Version_32 := 16#244fa59d#;
   pragma Export (C, u00241, "system__img_llbB");
   u00242 : constant Version_32 := 16#9f1f06a5#;
   pragma Export (C, u00242, "system__img_llbS");
   u00243 : constant Version_32 := 16#cd1fde06#;
   pragma Export (C, u00243, "system__img_llwB");
   u00244 : constant Version_32 := 16#36732533#;
   pragma Export (C, u00244, "system__img_llwS");
   u00245 : constant Version_32 := 16#811cd12a#;
   pragma Export (C, u00245, "system__img_wiuB");
   u00246 : constant Version_32 := 16#b09991c9#;
   pragma Export (C, u00246, "system__img_wiuS");
   u00247 : constant Version_32 := 16#14601ab4#;
   pragma Export (C, u00247, "v20__vstB");
   u00248 : constant Version_32 := 16#b4699839#;
   pragma Export (C, u00248, "v20__vstS");
   u00249 : constant Version_32 := 16#889acfab#;
   pragma Export (C, u00249, "gnat__expectB");
   u00250 : constant Version_32 := 16#a263c1e0#;
   pragma Export (C, u00250, "gnat__expectS");
   u00251 : constant Version_32 := 16#8f9f9fb7#;
   pragma Export (C, u00251, "gnat__regpatS");
   u00252 : constant Version_32 := 16#4ff5734c#;
   pragma Export (C, u00252, "system__regpatB");
   u00253 : constant Version_32 := 16#c46f777b#;
   pragma Export (C, u00253, "system__regpatS");
   u00254 : constant Version_32 := 16#2b93a046#;
   pragma Export (C, u00254, "system__img_charB");
   u00255 : constant Version_32 := 16#da01b4e3#;
   pragma Export (C, u00255, "system__img_charS");
   u00256 : constant Version_32 := 16#b31a5821#;
   pragma Export (C, u00256, "system__img_enum_newB");
   u00257 : constant Version_32 := 16#2779eac4#;
   pragma Export (C, u00257, "system__img_enum_newS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.latin_1%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.float_control%s
   --  system.float_control%b
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_char%s
   --  system.img_char%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.io%s
   --  system.io%b
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%s
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  system.unsigned_types%s
   --  system.img_biu%s
   --  system.img_biu%b
   --  system.img_llb%s
   --  system.img_llb%b
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.img_llw%s
   --  system.img_llw%b
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.img_wiu%s
   --  system.img_wiu%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%s
   --  system.wch_cnv%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.traceback%s
   --  system.traceback%b
   --  gnatcoll%s
   --  ada.characters.handling%s
   --  system.case_util%s
   --  system.img_real%s
   --  system.os_lib%s
   --  system.secondary_stack%s
   --  system.standard_library%s
   --  ada.exceptions%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.fat_llf%s
   --  system.soft_links%s
   --  system.val_lli%s
   --  system.val_llu%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  ada.exceptions.traceback%s
   --  ada.exceptions.traceback%b
   --  system.address_image%s
   --  system.address_image%b
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.bounded_strings%s
   --  system.bounded_strings%b
   --  system.case_util%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.containers%s
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.strings.maps%s
   --  ada.strings.maps%b
   --  ada.strings.maps.constants%s
   --  ada.tags%s
   --  ada.tags%b
   --  ada.streams%s
   --  ada.streams%b
   --  gnat%s
   --  gnat.debug_utilities%s
   --  gnat.debug_utilities%b
   --  gnat.htable%s
   --  gnat.htable%b
   --  gnat.io%s
   --  gnat.io%b
   --  interfaces.c%s
   --  interfaces.c%b
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.exceptions.machine%b
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  ada.characters.handling%b
   --  gnat.traceback%s
   --  gnat.traceback%b
   --  system.checked_pools%s
   --  gnat.debug_pools%s
   --  system.exception_traces%s
   --  system.exception_traces%b
   --  system.img_real%b
   --  system.mmap%s
   --  system.mmap.os_interface%s
   --  system.mmap%b
   --  system.mmap.unix%s
   --  system.mmap.os_interface%b
   --  system.object_reader%s
   --  system.object_reader%b
   --  system.dwarf_lines%s
   --  system.dwarf_lines%b
   --  system.os_lib%b
   --  system.secondary_stack%b
   --  system.soft_links.initialize%s
   --  system.soft_links.initialize%b
   --  system.soft_links%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  system.val_lli%b
   --  system.val_llu%b
   --  gnatcoll.memory%s
   --  system.memory%s
   --  system.memory%b
   --  gnat.debug_pools%b
   --  system.standard_library%b
   --  gnatcoll.memory%b
   --  ada.command_line%s
   --  ada.command_line%b
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.strings.fixed%s
   --  ada.strings.fixed%b
   --  gnat.os_lib%s
   --  gnat.strings%s
   --  interfaces.c.strings%s
   --  interfaces.c.strings%b
   --  ada.environment_variables%s
   --  ada.environment_variables%b
   --  system.fat_flt%s
   --  system.fat_lflt%s
   --  system.fat_sflt%s
   --  system.file_control_block%s
   --  system.file_io%s
   --  system.file_io%b
   --  system.finalization_masters%s
   --  system.finalization_masters%b
   --  system.os_constants%s
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.storage_pools.subpools%b
   --  system.stream_attributes%s
   --  system.stream_attributes.xdr%s
   --  system.stream_attributes.xdr%b
   --  system.stream_attributes%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.val_real%s
   --  system.val_real%b
   --  system.val_uns%s
   --  system.val_uns%b
   --  system.val_int%s
   --  system.val_int%b
   --  system.regpat%s
   --  system.regpat%b
   --  gnat.regpat%s
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.time_zones%s
   --  ada.calendar.time_zones%b
   --  ada.calendar.formatting%s
   --  ada.calendar.formatting%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.integer_aux%s
   --  ada.text_io.integer_aux%b
   --  ada.integer_text_io%s
   --  ada.integer_text_io%b
   --  gnat.directory_operations%s
   --  gnat.directory_operations%b
   --  system.file_attributes%s
   --  system.pool_global%s
   --  system.pool_global%b
   --  gnat.expect%s
   --  gnat.expect%b
   --  system.regexp%s
   --  system.regexp%b
   --  ada.directories%s
   --  ada.directories.hierarchical_file_names%s
   --  ada.directories.validity%s
   --  ada.directories.validity%b
   --  ada.directories%b
   --  ada.directories.hierarchical_file_names%b
   --  gnat.regexp%s
   --  gnat.command_line%s
   --  gnat.command_line%b
   --  v20%s
   --  v20.vst%s
   --  v20.vst%b
   --  v20.fls%s
   --  v20.prg%s
   --  v20.sys%s
   --  v20.prg%b
   --  v20.tio%s
   --  v20.tio%b
   --  v20%b
   --  v20.log%s
   --  v20.log%b
   --  v20.fls%b
   --  v20.sys%b
   --  aide%b
   --  END ELABORATION ORDER

end ada_main;
