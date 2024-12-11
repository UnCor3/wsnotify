#import <UserNotifications/UserNotifications.h> 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//todo: make rootless compatible 
// #import <rootless.h>

@interface SpringBoard : UIApplication
+ (id)sharedInstance;
@property (nonatomic, strong) NSURLSessionWebSocketTask *webSocketTask;
@property (nonatomic, strong) NSURLSession *session;
- (void)listenForMessages;
- (void)receiveMessageWithCompletionHandler:(void (^)(NSURLSessionWebSocketMessage *, NSError *))completionHandler;
- (void)pushNotificationWithMessage:(NSString *)message;
@end



%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    NSLog(@"init wsnotify");

    @try {
        // Create a URLSession
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        // Initialize the WebSocket task
		NSURL *url = [NSURL URLWithString:@"ws://192.168.1.61:8080"];
        self.webSocketTask = [self.session webSocketTaskWithURL:url];
        // Open the WebSocket connection
        [self.webSocketTask resume];
        // Start listening for messages
        [self listenForMessages];
    }
    @catch (NSException *exception) {

        NSLog(@"wsnotify An error occurred: %@, %@", exception.name, exception.reason);
    }
}

%new
- (void)listenForMessages {
    [self.webSocketTask receiveMessageWithCompletionHandler:^(NSURLSessionWebSocketMessage * _Nullable message, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error receiving message: %@", error);
            return;
        }
        // Process the received message
        if (message.type == NSURLSessionWebSocketMessageTypeString) {
            NSString *receivedText = message.string;
            NSLog(@"Received message: %@", receivedText);
            [self pushNotificationWithMessage:receivedText];
        }
        // Continue listening for messages
        [self listenForMessages];
    }];
}



// Method to send messages (if needed)
%new
- (void)sendMessage:(NSString *)message {
    NSURLSessionWebSocketMessage *webSocketMessage = [[NSURLSessionWebSocketMessage alloc] initWithString:message];
    [self.webSocketTask sendMessage:webSocketMessage completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

// Push notification method
%new
- (void)pushNotificationWithMessage:(NSString *)message {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"New Message";
    content.body = message;
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UniqueID" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}
%end
