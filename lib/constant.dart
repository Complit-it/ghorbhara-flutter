// const baseURL = 'http://192.168.29.125:8001/api';
// const baseUrl = 'http://192.168.29.125:8001/storage/';
const baseUrl = 'http://192.168.38.237:8001/storage/';
const baseURL = 'http://192.168.38.237:8001/api';

// 192.168.27.237

const loginURL = baseURL + '/login';
const signinURL = baseURL + '/signin';
const registerURL = baseURL + '/register';
const userUrl = baseURL + '/user';
const getOtpUrl = '$baseURL/getotp';
const verifyOtpUrl = baseURL + '/check-customer-otp';
const savePropUrl = baseURL + '/save_prop';
const getHomeFacUrl = baseURL + '/get_home_facility';
// const getPropTypeUrl = baseURL + '/get_property_type';
const getPropTypeUrl = '$baseURL/get_property_type';
const uploadPropUrl = baseURL + '/upload_property';
const getAllPropUrl = baseURL + '/get_all_property';
const getAdUrl = '$baseURL/get_ad';
const getAllAddUrl = '$baseURL/get_all_ads';
const getOnePropUrl = '$baseURL/get_one_prop';
const addTofav = '$baseURL/add_fav_prop';
const removeFav = '$baseURL/remove_fav_prop';
const searchPropUrl = '$baseURL/search_properties';
const registerGoogleUserUrl = '$baseURL/register_google_user';
const getFavPropUrl = '$baseURL/get_fav';
const getUserPropsUrl = '$baseURL/get_user_props';
const bookPropUrl = '$baseURL/save_booking_details';
//url to get booking requests
const getBookPropUrl = '$baseURL/get_booked_props';
//url to get booked props
const getBookedPropUrl = '$baseURL/getBookedPropertiesByUser';
const updateProfileUrl = '$baseURL/update_profile';
const testURL = '$baseURL/test';
const saveinqURL = '$baseURL/save_inquiry';

//KEYS
// const String _razorpayKeyy = 'rzp_test_NRUeeNsMSYtl4x';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
