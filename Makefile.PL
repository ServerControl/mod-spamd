use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Spamd',
   VERSION_FROM => 'lib/ServerControl/Module/Spamd.pm',
   PREREQ_PM => {'ServerControl' => '0.100'},
   LICENSE => 'bsd'
);

