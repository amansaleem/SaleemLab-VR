function index = getTextureIndex_N(str)

switch str
    case 'GRAY'
        index = 1;
    case 'WHITENOISE'
        index = 2;
    case 'WHITENOISE2'
        index = 3;
    case 'H_SQUARE_5cm_w'
        index = 4;
    case 'V_SQUARE_5cm_w'
        index = 5;
    case 'H_COS_GRA_5cm_w' 
        index = 6;
    case 'V_COS_GRA_5cm_w'
        index = 7;
    case 'COS_Plaid_5cm_w'
        index = 8;
    case 'WHITENOISE3'
        index = 9;
    case 'WHITENOISE4'
        index = 10;
    case 'Circ_COS_GRA'
        index = 11;
    case 'H_SQUARE_5cm_b'
        index = 12;
    case 'V_SQUARE_5cm_b' 
        index = 13;
    case 'H_COS_GRA_5cm_b'
        index = 14;
    case 'V_COS_GRA_5cm_b'
        index = 15;
    case 'COS_Plaid_5cm_b'
        index = 16;
    otherwise
        index = 2;
end