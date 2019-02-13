
/* Using Rainflow C-Library in a C++ context */

// "Cross-platform C++ Utility Library" [https://github.com/i42output/neolib]
#define HAVE_NEOLIB 0

#include "../rainflow.h"
#include "../greatest/greatest.h"

#define NUMEL(x) (sizeof(x)/sizeof(*(x)))

#if HAVE_NEOLIB
#include "../../neolib/include/neolib/segmented_array.hpp"
#else /*!HAVE_NEOLIB*/
#include <vector>
#endif /*HAVE_NEOLIB*/

// Declare user defined turning points storage (tp_storage)
namespace RFC_CPP_NAMESPACE
{
    typedef struct rfc_value_tuple rfc_value_tuple_s;  /**< Tuple of value and index position */
#if HAVE_NEOLIB
    class tp_storage : public neolib::segmented_array<rfc_value_tuple_s>
    {
        public:
            inline size_t capacity() const { return size(); }  /* Rainflow needs a capacity() method */
    };
#else /*!HAVE_NEOLIB*/
    typedef std::vector<rfc_value_tuple_s> tp_storage;  /**< Turning points storage */
#endif /*HAVE_NEOLIB*/
}


/* If RFC_TP_STORAGE is defined, rainflow.hpp will define the 
 * class Rainflow supporting external turning points storage 
 * with given type */
#define RFC_TP_STORAGE RFC_CPP_NAMESPACE::tp_storage
#include "../rainflow.hpp"




TEST wrapper_test_advanced( void )
{
/*
                                             |                                                                                
    8.5 _____________________________________|________________________________________________________________________________
                    +           o            |       +           o     +           o                                          
    7.5 _____________________________________|________________________________________________________________________________
                                             |                                                                                
    6.5 _____________________________________|________________________________________________________________________________
              +           +                  |             +                 +                                                
    5.5 _____________________________________|________________________________________________________________________________
                                             |                                                                                
    4.5 _____________________________________|________________________________________________________________________________
                                             |                                                                                
    3.5 _____________________________________|________________________________________________________________________________
                                             |                                                                                
    2.5 _____________________________________|________________________________________________________________________________
                 +           +               |                +                 +                                             
    1.5 _____________________________________|________________________________________________________________________________
           +           +                     |    +     +           +     +                                                  
    0.5 _____________________________________|________________________________________________________________________________
           1  2  3  4  5  6  7  8            |    1  4  5  6  7  8  1  4  5  6  7  8                                          

    Counts 6-2 (2,3)                         |    6-2 (6,7) ; 8-1 (4,5) ; 8-1 (8,1) ; 6-2 (6,7) ; 8-1 (4,5)
    ( => 3x 6-2 ; 3x 8-1 )

    TP
    1: 8-1
    2: 6-2
    3: 6-2
    4: 8-1, 8-1
    5: 8-1, 8-1
    6: 6-2, 6-2
    7: 6-2, 6-2
    8: 8-1
*/
    Rainflow rf;
    Rainflow::rfc_wl_param_s wl_param;
    int flags;

    double values[] = { 1,6,2,8 };
    std::vector<double> data( values, values + 4 );

    rf.init( 10, 1, -0.5, 1 );

    rf.get_flags( &flags, /*debugging*/true );
    flags |= (int)Rainflow::RFC_FLAGS_LOG_CLOSED_CYCLES;
    rf.set_flags( flags, /*debugging*/ true );

    rf.feed( values, NUMEL(values) );
    ASSERT( rf.tp_storage().size() == 3 );

    rf.feed( data );
    ASSERT( rf.tp_storage().size() == 7 );

    rf.finalize( Rainflow::RFC_RES_REPEATED );
    ASSERT( rf.tp_storage().size() == 8 );

    ASSERT( rf.tp_storage()[0].tp_pos == 0 );
    ASSERT( rf.tp_storage()[1].tp_pos == 0 );
    ASSERT( rf.tp_storage()[2].tp_pos == 0 );
    ASSERT( rf.tp_storage()[3].tp_pos == 0 );
    ASSERT( rf.tp_storage()[4].tp_pos == 0 );
    ASSERT( rf.tp_storage()[5].tp_pos == 0 );
    ASSERT( rf.tp_storage()[6].tp_pos == 0 );
    ASSERT( rf.tp_storage()[7].tp_pos == 0 );

    ASSERT( rf.tp_storage()[0].value == 1 );
    ASSERT( rf.tp_storage()[1].value == 6 );
    ASSERT( rf.tp_storage()[2].value == 2 );
    ASSERT( rf.tp_storage()[3].value == 8 );
    ASSERT( rf.tp_storage()[4].value == 1 );
    ASSERT( rf.tp_storage()[5].value == 6 );
    ASSERT( rf.tp_storage()[6].value == 2 );
    ASSERT( rf.tp_storage()[7].value == 8 );

    rf.wl_param_get( wl_param );
    double damage_6_2 = pow( ( (6.0-2.0)/2 / wl_param.sx ), fabs(wl_param.k) ) / wl_param.nx;
    double damage_8_1 = pow( ( (8.0-1.0)/2 / wl_param.sx ), fabs(wl_param.k) ) / wl_param.nx;

    ASSERT( fabs( rf.tp_storage()[0].damage / ( damage_8_1*1/2 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[1].damage / ( damage_6_2*1/2 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[2].damage / ( damage_6_2*1/2 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[3].damage / ( damage_8_1*1/1 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[4].damage / ( damage_8_1*1/1 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[5].damage / ( damage_6_2*1/1 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[6].damage / ( damage_6_2*1/1 ) - 1 )   < 1e-10 );
    ASSERT( fabs( rf.tp_storage()[7].damage / ( damage_8_1*1/2 ) - 1 )   < 1e-10 );

    rf.deinit();

    PASS();
}

/* Test suite for rfc_test.c */
extern "C"
SUITE( RFC_WRAPPER_SUITE_ADVANCED )
{
    RUN_TEST( wrapper_test_advanced );
}