//
//  AddAgahi.swift
//  Master
//
//  Created by Sina khanjani on 4/26/1400 AP.
//  Copyright © 1400 AP iPersianDeveloper. All rights reserved.
//

import Foundation

// /api/v{version}/Estate // vase sabt agahi route/
/*
{
  "type": 0, // نوع آگهی ۱ یا ۲ dar safe 2 entekhab shode CHECK *********
  "buildingDocumentId": "3fa85f64-5717-4562-b3fc-2c963f66afa6", // noe sanad (new*)
  "buildingStructureTypeId": "3fa85f64-5717-4562-b3fc-2c963f66afa6", // id noe saze (new*)
  "title": "string", // onvan agahi CHECK ********
  "description": "string", // tozihat agahi CHECK *******
  "provinceId": 0, // id ostan CHECK *********
  "cityId": 0, // id shahr CHECK *********
  "estateUseId": "3fa85f64-5717-4562-b3fc-2c963f66afa6", // id category (marhale1) CHECK ***********
  "metr": 0, // metraj CHECK *********
  "estateTypeId": "3fa85f64-5717-4562-b3fc-2c963f66afa6", // id zir daste ya haman noe melk (safe2) CHECK ********
  "age": 0, // agar no bana nabod 0 ersal ok , CHECK ******
  "isNewAge": true, // aya no bana hast CHECK ******
  "priceBuy": 0, // qeymat kharid -- agar ejare bod sefr befrest CHECK ****
  "priceRent": 0, // ehare CHECK ****
  "priceMortgage": 0, // rahn CHECK ****
  "isMortgage": true, // // agar tike rahn kamel ro zade bod bayad true ersal kon. CHECK **********
  "isAgreementPriceBuy": true, // agar tik agahi forosh tavafoqi bod CHECK **********
  "isAgreementPriceRent": true, // agar tike ejare tavafoqi CHECK **********
  "isAgreementPriceMortgage": true, // agar tike rahn tavafoqi CHECK **********
  "countRoom": 0, // tedad otaq
  "featureIds": [ // id emkanat CHECK ****
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "conditionIds": [ // id sharayet CHECK ****
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "buildingPositionIds": [  // ids moqeyatha(new*)
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "viewTypeBuildingIds": [ // ids noe nama(new*)
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "latitude": 0, CHECK ****
  "longitude": 0, CHECK ****
  "address": "string", CHECK ******
  "videoId": "3fa85f64-5717-4562-b3fc-2c963f66afa6", // bade upload video y id mide va addres ham mide. CHECK*****
  "phoneNumber": "string", CHECK ********
  "pics": [ // id aksa
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ]
}
*/

/// response ya raygane ya poli
// raygan:::: msg sabt shod present she
// age poli bashe

/*
 return Ok(new ApiResponseDto { IsSuccess = true, Data =new {UrlPay = Constant.HostServer + "pay/redirecttopay?Type=4&&EstateId=" + estate.Id + "&&userId=",EstateId = estate.Id }, Msg = "لطفا این لینک را در مرورگر کاربر باز کنید" });
 */
