import '../../domain/model/local/faq.dart';

class GlobalStrings {
  GlobalStrings._();

  static const String capitalNGN = 'NGN';
  static const String lowerNGN = 'ngn';
  static const String naira = '₦';
  static const String USD = 'USD';

  /// API
  /// prod
  static const String webUrl = 'app.xtridelink_driver.com';
  static const String host = 'xtridelink.online';
  static const String socketUrl = 'wss://xtridelink.online/ws/rider/notifications/';

  /// staging
  // static const String webUrl = 'staging-app.xtridelink_driver.com';
  // static const String host = 'staging-api.xtridelink_driver.com';
  // static const String socketUrl = 'https://staging-realtime.xtridelink_driver.com';

  /// dev
  // static const String webUrl = 'dev-app.xtridelink_driver.com';
  // static const String host = 'dev-api.xtridelink_driver.com';
  // static const String socketUrl = 'https://dev-realtime.xtridelink_driver.com';

  static const String googleMapHost = 'maps.googleapis.com';
  static const String androidAPIKey = 'AIzaSyBleET_8VKw_ADzSNv7R83YTUb_WbFhPl8';
  static const String iosAPIKey = 'AIzaSyBleET_8VKw_ADzSNv7R83YTUb_WbFhPl8';

  static final List<Faq> faqs = [
    Faq(
        question: 'What is xtridelink_driver?',
        answer:
            '''xtridelink_driver is a logistics platform that connects logistics companies/riders with customers across Africa. Customers can place delivery requests through our web app, and logistics companies/riders can accept those requests and make the deliveries.

Our platform streamlines the entire logistics process, making it fast, easy, and convenient for both customers and logistics professionals.'''),
    Faq(
        question: 'Is xtridelink_driver available in my area?',
        answer:
            'We\'re constantly expanding our network to reach new customers and logistics professionals across Africa. To find out if xtridelink_driver is available in your area, simply visit the web app and check for available delivery options.'),
    Faq(
        question:
            'How can I trust that my deliveries will be handled safely and professionally?',
        answer:
            'At xtridelink_driver, we take safety and professionalism seriously. All of our logistics partners undergo rigorous training and background checks to ensure that they\'re equipped to handle deliveries safely and efficiently. Additionally, our web app provides real-time tracking and communication throughout the delivery process, so you can always stay informed about your delivery status.'),
    Faq(
        question: 'What types of deliveries can I make with xtridelink_driver?',
        answer:
            'xtridelink_driver is equipped to handle a wide range of delivery types, from food and retail deliveries to bulk goods and industrial equipment. Our logistics partners are equipped to handle deliveries of all sizes and types, ensuring that you can get the logistics support you need, no matter what you\'re delivering.'),
    Faq(
        question:
            'How does xtridelink_driver compare to other logistics platforms?',
        answer:
            'xtridelink_driver is uniquely focused on the African market, providing tailored logistics solutions that are designed to meet the unique needs of businesses and customers across the continent. Our platform is fast, reliable, and efficient, with real-time tracking and communication tools that ensure you\'re always in the loop. Plus, our logistics partners are carefully vetted to ensure that they\'re equipped to handle deliveries safely and professionally. When it comes to logistics in Africa, xtridelink_driver is the clear choice.'),
    Faq(
        question: 'How do I know my package will be delivered on time?',
        answer:
            'xtridelink_driver works with a network of reliable and experienced logistics companies to ensure that your package is delivered on time. We also provide real-time tracking so you can monitor the progress of your delivery.'),
    Faq(
        question: 'Can I get a delivery quote before booking a shipment?',
        answer:
            'Yes, xtridelink_driver provides instant quotes for your shipment based on factors such as distance, weight, and type of package. You can easily compare prices from different logistics companies and choose the one that fits your budget.'),
    Faq(
        question: 'What if there\'s a problem with my delivery?',
        answer:
            'xtridelink_driver has a customer support team available 24/7 to assist with any issues that may arise during the delivery process. Our logistics partners are also trained to handle unexpected situations and will work to resolve any problems as quickly as possible.'),
    Faq(
        question: 'Can I schedule a delivery in advance?',
        answer:
            'Yes, with xtridelink_driver you can schedule a delivery for a future date and time that works best for you. This is particularly helpful for businesses that need to make regular deliveries or have specific delivery windows.'),
  ];

  static final List<Faq> legal = [
    Faq(
        question: '1. Acceptance of Terms',
        answer:
            '''1.1.xtridelink_driverTM (a registered trademark of Kingsthrone Multi Business and Logistics Ltd) provides its Service (as defined below) to you, subject to this Terms of Service agreement (TOS). By accepting this TOS or by accessing or using the Services or our website located at https://www.xtridelink_driver.com/ , you acknowledge that you have read, understood, and agree to be bound by this TOS. If you are entering into this TOS on behalf of a company, business or other legal entity, you represent that you have the authority to bind such entity and its affiliates to this TOS, in which case the terms youself or yourselves shall refer to such entity and its affiliates. If you do not have such authority, or if you do not agree with this TOS, you must not accept this TOS and may not use the Service.

1.2.We reserve the right, at our sole discretion, to change or modify portions of this TOS at any time. If we do this, we will post the changes on this page and will indicate at the top of this page the date these terms were last revised. We will also notify you, either through the Services user interface, in an email notification or through other reasonable means. Any such changes will become effective no earlier than twelve (12) days after they are posted, except that changes addressing new functions of the Services or changes made for legal reasons will be effective immediately. Your continued use of the Service after the date any such changes become effective constitutes your acceptance of the new TOS.

1.3.You may be required to register with xtridelink_driver in order to access and use certain features of the Service. If you choose to register for the Service, you agree to provide and maintain true, accurate, current and complete information about yourself as prompted by the Service registration form. You acknowledge and agree that your use of certain features of the Services requires current and accurate information about you, including your address and mobile phone number. xtridelink_driver is not responsible for any delays or inabilities to use the Services that result from your providing false, inaccurate, incomplete or out-of-date information. Registration data and certain other information about you are governed by our Privacy Policy. If you are under 18 years old, you may use the Service, with registering, only with the approval of your parent or guardian.

1.4.You are responsible for maintaining the confidentiality of your password and account, if any, and are fully responsible for any and all activities that occur under your password or account. You agree to (a) immediately notify xtridelink_driver of any unauthorized use of your password or account or any other breach of security, and (b) ensure that you exit from your account at the end of each session when accessing the Service. xtridelink_driver will not be liable for any loss or damage arising from your failure to comply with this Section.

1.5.In addition, when using certain services, you will be subject to any additional terms applicable to such services that may be posted on the Service from time to time, including, without limitation, the Privacy Policy located at https://xtridelink_driver.com/privacy-policy  and the FAQ Guide, which describes in detail how you may use the xtridelink_driver Services. All such terms are hereby incorporated by reference into this TOS.
    '''),
    Faq(
        question: '2. Description of Service',
        answer:
            '''2.1.xtridelink_driver is a technology company that does not directly provide delivery and moving services and the Company is not a transportation and delivery provider. It is up our logistics partners (the "Service Providers") you are registered to, to accept your delivery requests and it is up to you (references to "You", "Your" or "User" shall mean references to each visitor to the Website (as defined below), as the context requires) to accept their quotes/rates for your delivery (the "service provider"). The service of the Company is to link you with your service Provider/s (the "logistics partners") through the use of an application supplied by xtridelink_driver and downloaded and installed by you on your single mobile or tablet device (the "Application") or Web application but does not nor is it intended to provide delivery services or any act that can be construed in any way as an act of a Delivery Provider. The Company is not responsible or liable for the acts and/or omissions of any Delivery Provider and/or any delivery or shipping cargo provided to you.
'''),
    Faq(
        question: '3. Mobile Services',
        answer:
            '''3.1.The Service includes certain services that are available via a mobile device, including (i) the ability to upload content to the Service via a mobile device, (ii) the ability to browse the Service and the Site from a mobile device and (iii) the ability to access certain features through an application downloaded and installed on a mobile device (collectively, the Mobile Services). To the extent you access the Service through a mobile device, your wireless service carriers standard charges, data rates and other fees may apply. In addition, downloading, installing, or using certain Mobile Services may be prohibited or restricted by your carrier, and not all Mobile Services may work with all carriers or devices. By using the Mobile Services, you agree that we may communicate with you regarding xtridelink_driver and other entities by SMS, Phone call or other electronic means to your mobile device and that certain information about your usage of the Mobile Services may be communicated to us. You agree that as part of the registration process, xtridelink_driver may request that you verify your mobile device via SMS. In the event you change or deactivate your mobile telephone number, you agree to promptly update your xtridelink_driver account information to ensure that your messages are not sent to the person that acquires your old number
'''),
    Faq(
        question: '4. General Conditions/Use of the Service',
        answer:
            '''4.1.Subject to the terms and conditions of this TOS, you may access and use the Service only for lawful purposes. All rights, title and interest in and to the Service and its components will remain with and belong exclusively to xtridelink_driver. You shall not (a) sub license, resell, rent, lease, transfer, assign, time share or otherwise make the Service available to any third party, except as set forth in Section 12; (b) use the Service in any unlawful manner (including without limitation in violation of any data, privacy or export control laws) or in any manner that interferes with or disrupts the integrity or performance of the Service or its components or otherwise violates our acceptable use of policy (as defined below), or (c) modify, adapt or hack the Service to, or otherwise attempt to gain unauthorized access to the Service or its related systems or networks. You shall comply with any codes of conduct, policies or other notices xtridelink_driver provides you or publishes in connection with the Service, and you shall promptly notify xtridelink_driver if you learn of a security breach related to the Service. We shall not have any liability or responsibility for the actions of any third party carrier that may provide shipping services for us in connection with the Service.

4.2.By voluntarily providing us with personal information, you hereby represent that you are the owner of such personal information or are otherwise authorized to provide it to your service provider through xtridelink_driver platform. You further agree that you are consenting to our collection, use, storage and/or disclosure of such personal information in accordance with this Policy. You acknowledge and agree that your communications with xtridelink_driver will inevitably result in the transfer of information, including personal information, across international boundaries. If you provide personal information your Service provider through our Service, you acknowledge and agree that such personal information may be transferred from your current location to the offices and servers of xtridelink_driver and the authorized third parties referred to herein, located in Nigeria, United States of America and other countries (the Other Countries) for storage and processing in accordance with this Policy. You acknowledge and agree that the privacy and data security laws of such Other Countries may be different from the privacy and data security laws in force in the country in which you reside and agree that the privacy and security laws in effect in the applicable Other Countries may govern how your personal information may be collected, used, stored and/or disclosed.

4.3.Any software that may be made available by xtridelink_driver in connection with the Service, including without limitation the plug-ins, (Software) contains proprietary and confidential information that is protected by applicable intellectual property and other laws. Subject to the terms and conditions of this TOS, xtridelink_driver hereby grants you a non-transferable, non-sub licensable and non-exclusive right and license to use the object code of any Software solely in connection with the Service, provided that you shall not (and shall not allow any third party to) copy, modify, create a derivative work of, reverse engineer, reverse assemble or otherwise attempt to discover any source code or sell, assign, sublicense or otherwise transfer any right in any Software. You agree not to access the Service by any means other than through the interface that is provided by xtridelink_driver for use in accessing the Service. Any rights not expressly granted herein are reserved and no license or right to use any trademark of xtridelink_driver or any third party is granted to you in connection with the Service.
'''),
    Faq(
        question: '5. Prohibited Shipments',
        answer:
            '''5.1.You may not tender for shipment any items prohibited by law as detailed by our courier partners or any of our other carrier partners.

5.2.We or your service provider reserve the right, but have no obligation, to open and inspect your shipment at any time and may permit and/or contact government authorities to carry out such inspections and seize shipments as they may consider appropriate. We may also photograph items in your shipment for our internal use in order to provide the Services. We reserve the right to reject or suspend the carriage of any prohibited items or any shipment that contains materials that may damage other shipments or that may constitute a risk to our equipment or employees or to those of our service providers. We may or may not notify you of any of the foregoing and we are not responsible for and hereby disclaim any liability relating to any non-delivery of any items that are prohibited by this TOS or by law and any such items may be turned over to authorities, discarded, or returned to the sender (in each case in Service providers sole discretion). You may request that your service provider and its agents or third-party business partners not open, remove packaging, or otherwise inspect your Pre-Packaged Shipment (defined herein). By doing so, you waive any right to reimbursement for loss or damage to your shipment, as further specified in this TOS. However, you acknowledge and agree that your service provider (and its agents or third-party business partners) may take such actions with respect to your shipment, even if you request otherwise, if your service provider determines in its sole discretion that such action is necessary to assess compliance with this TOS or is otherwise required by applicable law or regulation.
'''),
    Faq(
        question: '6. Payment and charges',
        answer:
            '''6.1.The use of the mobile Apps and Web app and the Service is free of charge according to your Service providers level of service; you will be required to provide Ship information and fund the means of payment (usually debit cards or ewallet) acceptable to xtridelink_driver. When you arrange for shipment, all charges for the shipment and any additional fees payable to your service provider (Charges) will be charged to the debit card, ewallet or other payment instrument associated with your account. You hereby authorize xtridelink_driver to bill your payment instrument for Charges in accordance with these Terms. Except as otherwise agreed by the parties, all charges, fees, or surcharges shall be those in effect at the time of shipping, available either via email, on the Site or in-apps. The applicable Charges will be based upon the characteristics of the shipment actually tendered to your service provider or rates agreed upon. If you dispute any Charges you must let xtridelink_driver or the Service Provider know within thirty days. xtridelink_driver does not have the right to add or change or adjust rates specified and agreed between customer and service provider.

6.2.Shippers are responsible for providing accurate and complete shipment information to service provider, including service selected, number, weight, and dimensions of shipments. If any aspect of the shipment information is incomplete or incorrect as determined by service provider/logistic partners in its sole discretion, service provider may adjust Charges at any time if stated on their T&Cs.

6.3.Once a delivery method and starting point/end point has been entered into the mobile app / Web app, it will provide Users with the quote from your service provider only, thus giving the right to our users to accept and reject each quote. By accepting a quote, you accept to pay the Delivery Price quoted inclusive of VAT/surcharges or any other charges.
'''),
    Faq(
        question: '7. Indemnity',
        answer:
            '''7.1.By accepting the User Terms and using the Service and the Application, the User shall indemnify the Company and keep the Company and service provider indemnified against all demands, claims, action, proceedings, costs, charges or expenses including but not limited to penalties, storage charges, retrieval and administrative costs, duties and taxes incurred, suffered or sustained by us in connection with the Service we have provided.
'''),
    Faq(
        question: '8. Responsibility for Loss or Damage',
        answer:
            '''8.1.If a shipment is lost or damaged while in service provider possession, you will need to contact your service provider. Your service provider may or may not provide insurance under xtridelink_driver platform. If your service provider has set up insurance on the platform customers shall be able to click yes or no to take extra cover. Your service providers T&Cs apply.
'''),
    Faq(
        question: '9. Referrals',
        answer:
            '''9.1.From time to time, xtridelink_driver platform allows service provider to add referral in app, may offer a referral program which enables you to earn credits redeemable for shipping services by sharing a unique referral link provided to you by your service provider through xtridelink_driver platform(Referral Link) with your friends and family
'''),
    Faq(
        question: '10. Applicable Law and Jurisdiction',
        answer:
            '''10.1.This Agreement will in all respects be governed by and construed under the laws of the Federal Republic of Nigeria.

10.2.The Parties hereby consent and submit to the exclusive jurisdiction of courts (depending which country you are in) in any dispute arising from or in connection with this Agreement.

10.3.We may update the User Terms from time to time which will apply to the use of the Company site at via www.xtridelink_driver.com  and such changes shall be binding on the User upon posting.

10.4.We reserve the right to revise the User Terms at any time without prior notice.
'''),
  ];
}
