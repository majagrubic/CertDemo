//
//  CertificateParser.h
//  CertViewer
//
//  Created by Maja on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <openssl/x509.h>


@interface CertificateParser : NSObject

+(NSString*) CertificateGetIssuerName:(X509 *)certificateX509 attribute:(const char*)attribute;
+(NSArray*) certificateGetIssuer:(X509*)certificateX509;
+(NSDate *) certificateGetExpiryDate:(X509 *)certificateX509;
+(NSDate *) certificateGetStartDate:(X509 *)certificateX509;
+(NSString*) certificateGetSerialNumber:(X509*) certificateX509;
+(NSString*) certificateGetKeyUsage:(X509*) certificateX509;
+(NSString*) certificateGetSubjectName:(X509 *)certificateX509 attribute:(const char*) attribute;
+(NSArray*) certificateGetSubject:(X509*)certificateX509;
+(int) getVersion:(X509*) certificateX509;
+(NSDictionary*) certificateGetPublicKey:(X509*) certificateX509;
+(NSString*) certificateGetAlgorithm:(X509*) certificateX509;
+(NSArray*) certificateGetExtensions:(X509*) certificateX509;
+(NSDictionary*) certificateGetPrivateKey:(EVP_PKEY *) privateKey;
+(NSArray*) certificateGetGeneralInfo:(X509 *) certificateX509;
+(NSDate*) getDate:(ASN1_GENERALIZEDTIME*) asn1Generealized;
+(NSString*) certificateGetFingerprint:(X509*) certificateX509 digestAlg:(NSString*)digestAlg;
@end
