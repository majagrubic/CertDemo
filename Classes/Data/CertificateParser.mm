  //
//  CertificateParser.m
//  CertViewer
//
//  Created by Maja on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CertificateParser.h"
#import "Extension.h"
#import <openssl/crypto.h>
#import <openssl/engine.h>
#import <openssl/x509v3.h>
#import <sys/utsname.h>
#import <openssl/asn1.h>
#import <string.h>

using namespace std;

@implementation CertificateParser

/*
 possible attribute values:
 C - country name
 E -
 ST - state or province
 L - locality name
 O - organization 
 OU - organizational unit
 CN - common name
 DN - distinguished name
 */
+(NSString*) CertificateGetIssuerName:(X509 *)certificateX509 attribute:(const char*) attribute
{
    NSString *issuer = nil;
    if (certificateX509 != NULL) {
        X509_NAME *issuerX509Name = X509_get_issuer_name(certificateX509);
        if (issuerX509Name != NULL) {
            int nid = OBJ_txt2nid(attribute); 
            int index = X509_NAME_get_index_by_NID(issuerX509Name, nid, -1);
            X509_NAME_ENTRY *issuerNameEntry = X509_NAME_get_entry(issuerX509Name, index);
            
            if (issuerNameEntry != NULL) {
                ASN1_STRING *issuerNameASN1 = X509_NAME_ENTRY_get_data(issuerNameEntry);
                
                if (issuerNameASN1 != NULL) {
                    unsigned char *issuerName = ASN1_STRING_data(issuerNameASN1);
                    issuer = [NSString stringWithUTF8String:(char *)issuerName];
                }
            }
        }
    }
    
    return issuer;
}



+(NSArray*) certificateGetIssuer:(X509*)certificateX509 {    
    NSMutableArray *issuerArray = [[[NSMutableArray alloc] init] autorelease];
   
    if (certificateX509 != NULL) {
        X509_NAME *issuerX509Name = X509_get_issuer_name(certificateX509);
        if (issuerX509Name != NULL) {
            int n = X509_NAME_entry_count(issuerX509Name);
            for (int i = 0; i<n; i++) {
                NSMutableDictionary *issuerDict = [[NSMutableDictionary alloc] init];
                X509_NAME_ENTRY *issuerNameEntry = X509_NAME_get_entry(issuerX509Name, i);
                
                if (issuerNameEntry != NULL) {
                    ASN1_STRING *issuerNameASN1 = X509_NAME_ENTRY_get_data(issuerNameEntry);
                    ASN1_OBJECT *obj = X509_NAME_ENTRY_get_object(issuerNameEntry);
                    if (obj != NULL && issuerNameASN1 != NULL) {
                        int nid =  OBJ_obj2nid(obj);
                        const char *attribute = OBJ_nid2sn(nid);
                        unsigned char *issuerName = ASN1_STRING_data(issuerNameASN1);
                        NSString *issuer = [NSString stringWithUTF8String:(char *)issuerName];
                        [issuerDict setValue:issuer forKey:[NSString stringWithUTF8String:(char*) attribute]];
                    }
                }

                [issuerArray addObject:issuerDict];
                [issuerDict release];
                
            }
        }
    }
    
    return issuerArray;
    
}


+(NSDate *) certificateGetExpiryDate:(X509 *)certificateX509
{
    NSDate *expiryDate = nil;
    
    if (certificateX509 != NULL) {
        ASN1_TIME *certificateExpiryASN1 = X509_get_notAfter(certificateX509);
        if (certificateExpiryASN1 != NULL) {
            ASN1_GENERALIZEDTIME *certificateExpiryASN1Generalized = ASN1_TIME_to_generalizedtime(certificateExpiryASN1, NULL);
            if (certificateExpiryASN1Generalized != NULL) {
                expiryDate = [CertificateParser getDate:certificateExpiryASN1Generalized];
            }
        }
    }
    
    return expiryDate;
}


+(NSDate *) certificateGetStartDate:(X509 *)certificateX509
{
    NSDate *startDate = nil;
    
    if (certificateX509 != NULL) {
        ASN1_TIME *certificateStartASN1 = X509_get_notBefore(certificateX509);
        if (certificateStartASN1 != NULL) {
            ASN1_GENERALIZEDTIME *certificateExpiryASN1Generalized = ASN1_TIME_to_generalizedtime(certificateStartASN1, NULL);
            if (certificateExpiryASN1Generalized != NULL) {
                startDate = [CertificateParser getDate:certificateExpiryASN1Generalized];
            }
        }
    }
    
    return startDate;
}

+(NSDate*) getDate:(ASN1_GENERALIZEDTIME*) asn1Generealized {
    NSDate *date;
    unsigned char *data = ASN1_STRING_data(asn1Generealized);
    
    // ASN1 generalized times look like this: "20131114230046Z"
    //                                format:  YYYYMMDDHHMMSS
    //                               indices:  01234567890123
    //                                                   1111
    
    NSString *expiryTimeStr = [NSString stringWithUTF8String:(char *)data];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents.year   = [[expiryTimeStr substringWithRange:NSMakeRange(0, 4)] intValue];
    dateComponents.month  = [[expiryTimeStr substringWithRange:NSMakeRange(4, 2)] intValue];
    dateComponents.day    = [[expiryTimeStr substringWithRange:NSMakeRange(6, 2)] intValue];
    dateComponents.hour   = [[expiryTimeStr substringWithRange:NSMakeRange(8, 2)] intValue];
    dateComponents.minute = [[expiryTimeStr substringWithRange:NSMakeRange(10, 2)] intValue];
    dateComponents.second = [[expiryTimeStr substringWithRange:NSMakeRange(12, 2)] intValue];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    date = [calendar dateFromComponents:dateComponents];
    [dateComponents release];
    
    return date;

}

+(NSString*) certificateGetSubjectName:(X509 *)certificateX509 attribute:(const char*) attribute
{
    NSString *subject = nil;
    if (certificateX509 != NULL) {
        X509_NAME *subjectX509Name = X509_get_subject_name(certificateX509);
        
        if (subjectX509Name != NULL) {
            int nid = OBJ_txt2nid(attribute); 
            int index = X509_NAME_get_index_by_NID(subjectX509Name, nid, -1);
            
            X509_NAME_ENTRY *subjectNameEntry = X509_NAME_get_entry(subjectX509Name, index);
            if (subjectNameEntry) {
                ASN1_STRING *subjectNameASN1 = X509_NAME_ENTRY_get_data(subjectNameEntry);
                
                if (subjectNameASN1 != NULL) {
                    unsigned char *subjectName = ASN1_STRING_data(subjectNameASN1);
                    subject = [NSString stringWithUTF8String:(char *)subjectName];
                }
            }
        }
    }
    return subject;
}


+(NSArray*) certificateGetSubject:(X509*)certificateX509 {    
    NSMutableArray *subjectArray = [[[NSMutableArray alloc] init] autorelease];
    
    if (certificateX509 != NULL) {
       X509_NAME *subjectX509Name = X509_get_subject_name(certificateX509);
        if (subjectX509Name != NULL) {
            int n = X509_NAME_entry_count(subjectX509Name);
            for (int i = 0; i<n; i++) {
                NSMutableDictionary *subjectDict = [[NSMutableDictionary alloc] init];
                X509_NAME_ENTRY *subjectNameEntry = X509_NAME_get_entry(subjectX509Name, i);
                
                if (subjectNameEntry != NULL) {
                    ASN1_STRING *subjectNameASN1 = X509_NAME_ENTRY_get_data(subjectNameEntry);
                    ASN1_OBJECT *obj = X509_NAME_ENTRY_get_object(subjectNameEntry);
                    if (obj != NULL && subjectNameASN1 != NULL) {
                        int nid =  OBJ_obj2nid(obj);
                        const char *attribute = OBJ_nid2sn(nid);
                        unsigned char *subjectName = ASN1_STRING_data(subjectNameASN1);
                        NSString *subject = [NSString stringWithUTF8String:(char *)subjectName];
                        [subjectDict setValue:subject forKey:[NSString stringWithUTF8String:(char*) attribute]];
                    }
                }
                
                [subjectArray addObject:subjectDict];
                [subjectDict release];
                
            }
        }
    }
    
    return subjectArray;

}

+(NSDictionary*) certificateGetPrivateKey:(EVP_PKEY *) privateKey {
    NSMutableDictionary *privateKeyInfo = [[[NSMutableDictionary alloc] init] autorelease];
    if (privateKey == NULL) {
        return privateKeyInfo;
    }
    
    if (privateKey -> type != EVP_PKEY_DSA && privateKey -> type != EVP_PKEY_RSA) {
        [privateKeyInfo setObject:@"Unsupported algorithm type" forKey:@"Error"];
        return privateKeyInfo;
    }
    
    ENGINE_load_builtin_engines();
    ENGINE_register_all_complete();
    
    int outl;
    BIGNUM *bn;
    if (privateKey->type == EVP_PKEY_RSA) {
        [privateKeyInfo setValue:@"RSA" forKey:@"Algorithm"];
        bn = privateKey-> pkey.rsa ->n;
    } else if (privateKey->type == EVP_PKEY_DSA) {
        [privateKeyInfo setValue:@"DSA" forKey:@"Algorithm"];
        bn = privateKey-> pkey.dsa ->priv_key;
    }

     outl=EVP_PKEY_size(privateKey);
    //extracts the bytes from public key & convert into unsigned char buffer
    int buf_len = (size_t) BN_num_bytes (bn);
    unsigned char * buf_out=(unsigned char *)OPENSSL_malloc((unsigned int)buf_len);
    int i_n = BN_bn2bin (bn, buf_out);
    [privateKeyInfo setValue:[NSString stringWithFormat:@"%d", (outl*8)] forKey:@"Length"];
    
    NSMutableString *key = [[NSMutableString alloc] init];
    for (int y=0; y<i_n; y++) {
        [key appendString:[NSString stringWithFormat:@"%.02x ", buf_out[y]]];
    }
    [privateKeyInfo setValue:key forKey:@"Key"];
    [key release];

    return privateKeyInfo;
}


+(NSString*) certificateGetSerialNumber:(X509*) certificateX509 
{
    ASN1_INTEGER *serial = X509_get_serialNumber(certificateX509);
    BIGNUM *bnser = ASN1_INTEGER_to_BN(serial, NULL);
    int n = BN_num_bytes(bnser);
    unsigned char outbuf[n];
    int bin = BN_bn2bin(bnser, outbuf);
    char *buf = (char*) outbuf;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i=0; i<n; i++) {
        unsigned int br = buf[i];
        NSString *temp = [NSString stringWithFormat:@"%.6x", br];
        if ([temp hasPrefix:@"ffffff"] || [temp hasPrefix:@"FFFFFF"]) {
            temp = [temp substringWithRange:NSMakeRange(6, 2)];
        } else {
            temp = [temp substringWithRange:NSMakeRange(4, 2)];
        }
        [str appendString:[NSString stringWithFormat:@"%@ ", temp]];
    }
    
    return [str autorelease];
}

+(int) getVersion:(X509*) certificateX509 
{
    if (certificateX509 == NULL) return 0;
    int v = X509_get_version(certificateX509);
    return (v+1);
}

+(NSString*) certificateGetAlgorithm:(X509*) certificateX509 {
    X509_ALGOR *alg= certificateX509 -> sig_alg;
    ASN1_OBJECT *algObject = alg-> algorithm;
    
    int nid =  OBJ_obj2nid(algObject);
    const char *objCh =  OBJ_nid2ln(nid);
    
    return [NSString stringWithUTF8String:objCh];
}

+(NSString*) signatureGetParameters:(X509*) certificateX509 {
    X509_ALGOR *alg= certificateX509 -> sig_alg;
    ASN1_OBJECT *algObject = alg-> algorithm;
    
    ASN1_TYPE *parameter = alg -> parameter;
    
    char objbuf[80];
    const char *ln;
    NSMutableString *output = [[[NSMutableString alloc]init] autorelease];
    NSDate *date;
    // Collect the things from the ASN1_TYPE structure
    switch(parameter->type)
    {
        case V_ASN1_BOOLEAN:
            [output appendString:[NSString stringWithFormat:@"%@", parameter-> value.boolean ? @"true" : @"false"]];
            break;
            
        case V_ASN1_INTEGER:
            [output appendString:[NSString stringWithFormat:@"%s", i2s_ASN1_INTEGER(NULL,parameter->value.integer)]];
            break;
            
        case V_ASN1_ENUMERATED:
            [output appendString:[NSString stringWithFormat:@"%s", i2s_ASN1_INTEGER(NULL,parameter->value.enumerated)]];
            break;
            
        case V_ASN1_NULL:
           [output appendString:@"none"];
            break;
            
        case V_ASN1_UTCTIME:
            //  ASN1_UTCTIME_print(bio,ptr->value.utctime);
            break;
            
        case V_ASN1_GENERALIZEDTIME:
            date = [CertificateParser getDate:parameter -> value.generalizedtime];
            // ASN1_GENERALIZEDTIME_print(bio,ptr->value.generalizedtime);
            break;
            
        case V_ASN1_OBJECT:
            ln = OBJ_nid2ln(OBJ_obj2nid(parameter->value.object));
            if( !ln ) ln = "";
            OBJ_obj2txt(objbuf,sizeof(objbuf),parameter->value.object,1);
            [output appendString:[NSString stringWithFormat:@"%s", objbuf]];
            break;
            
        default :
           [output appendString:@"Unknown"];
            break;
    }
    
    return output;

}


+(NSArray*) certificateGetExtensions:(X509*) certificateX509 {
    X509_EXTENSIONS *exts = certificateX509 -> cert_info -> extensions;
    const char *ln;
    char objbuf[80];
    
    //verzija 1 ne podrzava ekstenzije
    if(!X509_get_version(certificateX509)) {
        return  nil;
    }
    
    NSMutableArray *extensions = [[[NSMutableArray alloc] init] autorelease];
    while (YES) {
        X509_EXTENSION *extension =  sk_X509_EXTENSION_pop(exts);
        if (extension == NULL) {
            break;
        }
        ASN1_OBJECT *obj = extension-> object;
        
        int critical =  X509_EXTENSION_get_critical(extension);
        ASN1_OCTET_STRING *data= X509_EXTENSION_get_data(extension);
        
        ln = OBJ_nid2ln(OBJ_obj2nid(obj));
        if( !ln ) ln = "";
        OBJ_obj2txt(objbuf,sizeof(objbuf),obj,1);
        int nid = OBJ_txt2nid(ln);
       
        Extension *ext = [[Extension alloc] initWithNid:[NSString stringWithUTF8String:objbuf] andName:[NSString stringWithUTF8String:ln]];
        ext.critical = (critical == 0) ? NO : YES;
        
       
        int z = i2d_X509(certificateX509, NULL);
        char *m = (char*) OPENSSL_malloc(z);
        unsigned char*d = (unsigned char*) m;
        z=  i2d_X509_EXTENSION(extension, &d);
        
        void *bs;
        bs = X509_get_ext_d2i(certificateX509, nid, NULL, NULL); 
        
        
        ASN1_OCTET_STRING *value = extension -> value;
        d = (unsigned char*)m;
        z = i2d_ASN1_OCTET_STRING(value, &d);
        d = (unsigned char*)m;
        for(int i=0; i<z; i++) {
            NSLog(@"%c", d[i]);
        }
     
       
        unsigned char* octet_str_data = X509_EXTENSION_get_data(extension) -> data;
        if (octet_str_data  != NULL) {
             NSLog(@"%s", octet_str_data);     
            long xlen;
            int tag, xclass;

           
       /*     if (octet_str_data != NULL) {
                NSLog(@"%s ", octet_str_data);
                 NSLog(@"%d", sizeof(octet_str_data)/sizeof(octet_str_data[0]));
                 std::vector<unsigned char> bytes(octet_str_data, octet_str_data + sizeof(octet_str_data));
                 conversion::der::decoder myderdecoder(true);
                 conversion::der::array der_objects;
                 myderdecoder.decode_data(bytes, der_objects);
            }*/
        }
    
        [extensions addObject:ext];
    }
    
    NSArray* reversedArray = [[extensions reverseObjectEnumerator] allObjects];
   
    return reversedArray;

}


+(NSDictionary*) certificateGetPublicKey:(X509*) certificateX509 {
    EVP_PKEY *pubKey = X509_get_pubkey(certificateX509);
    NSMutableDictionary *publicKeyInfo = [[[NSMutableDictionary alloc] init] autorelease];
    
    if (pubKey->type == EVP_PKEY_RSA) {
        [publicKeyInfo setValue:@"RSA" forKey:@"Algorithm"];
        char *ptr = pubKey -> pkey.ptr;
        NSLog(@"%c", ptr[0]);
        
        BIGNUM *e = pubKey -> pkey.rsa -> e;
        unsigned int *ed = e->d;
        int d= ed[0];
        [publicKeyInfo setValue:[NSString stringWithFormat:@"%d", d] forKey:@"Exponent"];
        
        BIGNUM *n = pubKey -> pkey.rsa -> n;
        unsigned int *nd = n->d;
        
    }

    int z = i2d_X509(certificateX509, NULL);
    char *m = (char*) OPENSSL_malloc(z);
    unsigned char*d = (unsigned char*) m;
    z=i2d_X509_PUBKEY(X509_get_X509_PUBKEY(certificateX509),&d);

    X509_PUBKEY *x = certificateX509 -> cert_info -> key;
    ASN1_BIT_STRING *pk = x->public_key;

    d = (unsigned char*)m;
    z = i2c_ASN1_BIT_STRING(pk, &d);
    d = (unsigned char*)m;
    NSMutableString *pubKeyString = [[NSMutableString alloc] init];
    
    //remove leading padding
    int start = 0;
    for (int y=0; y<z-5; y++) {
        if (d[y]==0 && y !=0) {
            start = y + 1;
            break;
        }
    }
    
    int length = 0;
    for (int y=start; y<z-5; y++)
    {
        //NSLog(@"0x%02X,",d[y]);
        length++;
        [pubKeyString appendString:[NSString stringWithFormat:@"%02x ", d[y]]];
    }
    //length should be in bits
    length*=8;
    
    [publicKeyInfo setObject:pubKeyString forKey:@"PubKey"];
    [pubKeyString release];
    [publicKeyInfo setObject:[NSString stringWithFormat:@"%d", length] forKey:@"KeySize"];

    ASN1_BIT_STRING *signature = certificateX509 -> signature;
    d = (unsigned char*)m;
    z = i2c_ASN1_BIT_STRING(signature, &d);
    d = (unsigned char*)m;

    NSMutableString *signatureString = [[NSMutableString alloc] init];
    for (int y=1; y<z; y++) {
        [signatureString appendString:[NSString stringWithFormat:@"%02X ", d[y]]];
    }
    [publicKeyInfo setObject:signatureString forKey:@"Signature"];
    [signatureString release];
    
    return publicKeyInfo;
}

+(NSString*) certificateGetKeyUsage:(X509*) certificateX509 {
  
    int ca = X509_check_ca(certificateX509);
    long long usage = certificateX509->ex_kusage;
    NSString *keyUsage = @"";
    if (usage == KU_DIGITAL_SIGNATURE) {
        keyUsage = @"Digital Signature";
    } else if (usage == KU_NON_REPUDIATION) {
        keyUsage = @"Non Repudiation";
    } else if (usage == KU_KEY_ENCIPHERMENT) {
        keyUsage = @"Key Encipherment";
    } else if (usage == KU_DATA_ENCIPHERMENT) {
        keyUsage = @"Data Encipherment";
    } else if (usage == KU_KEY_AGREEMENT) {
        keyUsage = @"Key Agreement";
    } else if (usage == KU_KEY_CERT_SIGN) {
        keyUsage = @"Certificate Sign";
    } else if (usage == KU_KEY_CERT_SIGN) {
        keyUsage = @"CRL Sign";
    } else if (usage ==  KU_ENCIPHER_ONLY) {
        keyUsage = @"Encipher";
    } else if (usage == KU_DECIPHER_ONLY) {
        keyUsage = @"Decipher";
    }
    return keyUsage;
}


+(void) print:(ASN1_TYPE *) ptr
{
    // memory bio to collect the output.
    char objbuf[80];
    const char *ln;
    
    // Collect the things from the ASN1_TYPE structure
    switch(ptr->type)
    {
        case V_ASN1_BOOLEAN:
            NSLog(@"%@", ptr->value.boolean ? @"true" : @"false");
            break;
            
        case V_ASN1_INTEGER:
            NSLog(@"%s",i2s_ASN1_INTEGER(NULL,ptr->value.integer));
            break;
            
        case V_ASN1_ENUMERATED:
            
            NSLog(@"%s",i2s_ASN1_INTEGER(NULL,ptr->value.enumerated));
            break;
            
        case V_ASN1_NULL:
            NSLog(@"NULL");
            break;
            
        case V_ASN1_UTCTIME:
          //  ASN1_UTCTIME_print(bio,ptr->value.utctime);
            break;
            
        case V_ASN1_GENERALIZEDTIME:
            break;
            
        case V_ASN1_OBJECT:
            ln = OBJ_nid2ln(OBJ_obj2nid(ptr->value.object));
            if( !ln ) ln = "";
            OBJ_obj2txt(objbuf,sizeof(objbuf),ptr->value.object,1);
            NSLog(@"%s", objbuf);
            break;
            
        default :
           NSLog(@"Unknown");
            break;
    }
    
}

+(NSArray*) certificateGetGeneralInfo:(X509 *) certificateX509 {
    NSMutableArray *generalInfoArray = [[NSMutableArray alloc] init];
    [generalInfoArray addObject:[CertificateParser certificateGetSerialNumber:certificateX509]];
    [generalInfoArray addObject:[NSString stringWithFormat:@"%d", [CertificateParser getVersion:certificateX509]]];
    [generalInfoArray addObject:[CertificateParser certificateGetAlgorithm:certificateX509 ]];
    [generalInfoArray addObject:[CertificateParser signatureGetParameters:certificateX509]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy hh:mm"];
    NSDate *date = [CertificateParser certificateGetStartDate:certificateX509];
    [generalInfoArray addObject:[formatter stringFromDate:date]];
    date = [CertificateParser certificateGetExpiryDate:certificateX509];
    [generalInfoArray addObject:[formatter stringFromDate:date]];
    [formatter release];
    return [generalInfoArray autorelease];
}


+(NSString*) certificateGetFingerprint:(X509*) certificateX509 digestAlg:(NSString*)digestAlg { 
    if (certificateX509 == NULL) {
        return @"";
    }
    OpenSSL_add_all_digests();
    const EVP_MD        * digest;
    const char *digestName = [digestAlg UTF8String];
    digest = EVP_get_digestbyname(digestName);
    unsigned char *md;
    if ([digestAlg isEqualToString:@"sha1"]) {
        md = (unsigned char *) (malloc(20 * sizeof(unsigned char*)));
    } else if ([digestAlg isEqualToString:@"md5"]) {
        md = (unsigned char *) (malloc(16 * sizeof(unsigned char*)));
    }
  
    unsigned int          n;
    
    X509_digest(certificateX509, digest, md, &n);
    NSMutableString *fingerprint = [[[NSMutableString alloc] init] autorelease];
    int pos;
    for(pos = 0; pos < n; pos++) {
        [fingerprint appendString:[NSString stringWithFormat:@"%02X ", md[pos]]];
    }
    return fingerprint;
}



@end
