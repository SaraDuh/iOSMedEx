//
//  Stripe+ApplePay.m
//  Stripe
//
//  Created by Jack Flintermann on 9/17/14.
//

#import "Stripe+ApplePay.h"
#import "STPAPIClient.h"

FAUXPAS_IGNORED_IN_FILE(APIAvailability)

@implementation Stripe (ApplePay)

+ (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest {
    if (paymentRequest == nil) {
        return NO;
    }
    return [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentRequest.supportedNetworks];
}

+ (PKPaymentRequest *)paymentRequestWithMerchantIdentifier:(NSString *)merchantIdentifier {
    if (![PKPaymentRequest class]) {
        return nil;
    }
    PKPaymentRequest *paymentRequest = [PKPaymentRequest new];
    [paymentRequest setMerchantIdentifier:merchantIdentifier];
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    if (@available(iOS 9.0, *)) {
        if ((&PKPaymentNetworkDiscover) != NULL) {
            supportedNetworks = [supportedNetworks arrayByAddingObject:PKPaymentNetworkDiscover];
        }
    } else {
        // Fallback on earlier versions
    }
    [paymentRequest setSupportedNetworks:supportedNetworks];
    [paymentRequest setMerchantCapabilities:PKMerchantCapability3DS];
    [paymentRequest setCountryCode:@"US"];
    [paymentRequest setCurrencyCode:@"USD"];
    return paymentRequest;
}

+ (void)createTokenWithPayment:(PKPayment *)payment
                    completion:(STPCompletionBlock)handler {
    [self createTokenWithPayment:payment
                  operationQueue:[NSOperationQueue mainQueue]
                      completion:handler];
}

+ (void)createTokenWithPayment:(PKPayment *)payment
                operationQueue:(NSOperationQueue *)queue
                    completion:(STPCompletionBlock)handler {
    STPAPIClient *client = [[STPAPIClient alloc] init];
    client.operationQueue = queue;
    [client createTokenWithPayment:payment completion:handler];
}

@end

void linkStripeApplePayCategory(void){}