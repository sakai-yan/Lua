
$def TestOn11 DoNothing

XG_ImportFile( "XueYue\\xJass\\emptyFile", "TestOn11" )

#ifdef DZAPIINCLUDE
#undef DZAPIINCLUDE
#endif

#include "XueYue\\xJass\\DzAPI.j"

#ifdef BZAPIINCLUDE
#undef BZAPIINCLUDE
#endif
#include "XueYue\\xJass\\BlizzardAPI.j"

