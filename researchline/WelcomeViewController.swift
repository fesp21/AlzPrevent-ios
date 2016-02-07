//
//  WelcomeViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import ResearchKit

class WelcomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    // MARK: Types
    
    /**
    Every step and task in the ResearchKit framework has to have an identifier.
    Within a task, the step identifiers should be unique.
    
    Here we use an enum to ensure that the identifiers are kept unique. Since
    the enum has a raw underlying type of a `String`, the compiler can determine
    the uniqueness of the case values at compile time.
    
    In a real application, the identifiers for your tasks and steps might
    come from a database, or in a smaller application, might have some
    human-readable meaning.
    */
    private enum Identifier {
        // Task with a form, where multiple items appear on one page.
        case FormTask
        case FormStep
        case FormItem01
        case FormItem02
        case FormItem03
        
        // Survey task specific identifiers.
        case SurveyTask
        case IntroStep
        case QuestionStep
        case SummaryStep
        
        // Task with a Boolean question.
        case BooleanQuestionTask
        case BooleanQuestionStep
        
        // Task with an example of date entry.
        case DateQuestionTask
        case DateQuestionStep
        
        // Task with an example of date and time entry.
        case DateTimeQuestionTask
        case DateTimeQuestionStep
        
        // Task with an image choice question.
        case ImageChoiceQuestionTask
        case ImageChoiceQuestionStep
        
        // Task with a location entry.
        case LocationQuestionTask
        case LocationQuestionStep
        
        // Task with examples of numeric questions.
        case NumericQuestionTask
        case NumericQuestionStep
        case NumericNoUnitQuestionStep
        
        // Task with examples of questions with sliding scales.
        case ScaleQuestionTask
        case DiscreteScaleQuestionStep
        case ContinuousScaleQuestionStep
        case DiscreteVerticalScaleQuestionStep
        case ContinuousVerticalScaleQuestionStep
        case TextScaleQuestionStep
        case TextVerticalScaleQuestionStep
        
        // Task with an example of free text entry.
        case TextQuestionTask
        case TextQuestionStep
        
        // Task with an example of a multiple choice question.
        case TextChoiceQuestionTask
        case TextChoiceQuestionStep
        
        // Task with an example of time of day entry.
        case TimeOfDayQuestionTask
        case TimeOfDayQuestionStep
        
        // Task with an example of time interval entry.
        case TimeIntervalQuestionTask
        case TimeIntervalQuestionStep
        
        // Task with a value picker.
        case ValuePickerChoiceQuestionTask
        case ValuePickerChoiceQuestionStep
        
        // Task with an example of validated text entry.
        case ValidatedTextQuestionTask
        case ValidatedTextQuestionStepEmail
        case ValidatedTextQuestionStepDomain
        
        // Image capture task specific identifiers.
        case ImageCaptureTask
        case ImageCaptureStep
        
        // Task with an example of waiting.
        case WaitTask
        case WaitStepDeterminate
        case WaitStepIndeterminate
        
        // Eligibility task specific indentifiers.
        case EligibilityTask
        case EligibilityIntroStep
        case EligibilityFormStep
        case EligibilityFormItem01
        case EligibilityFormItem02
        case EligibilityFormItem03
        case EligibilityIneligibleStep
        case EligibilityEligibleStep
        
        // Consent task specific identifiers.
        case ConsentTask
        case VisualConsentStep
        case ConsentSharingStep
        case ConsentReviewStep
        case ConsentDocumentParticipantSignature
        case ConsentDocumentInvestigatorSignature
        
        // Account creation task specific identifiers.
        case AccountCreationTask
        case RegistrationStep
        case WaitStep
        case VerificationStep
        
        // Login task specific identifiers.
        case LoginTask
        case LoginStep
        case LoginWaitStep
        
        // Passcode task specific identifiers.
        case PasscodeTask
        case PasscodeStep
        
        // Active tasks.
        case AudioTask
        case FitnessTask
        case HolePegTestTask
        case PSATTask
        case ReactionTime
        case ShortWalkTask
        case SpatialSpanMemoryTask
        case TimedWalkTask
        case ToneAudiometryTask
        case TowerOfHanoi
        case TwoFingerTappingIntervalTask
    }
    
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    Constants.userDefaults.setObject(Constants.STEP_READY, forKey: "registerStep")

    navigationController?.navigationBarHidden = true
  }

  @IBAction func touchUpInsideJoinStudyButton(sender: UIButton) {
    
    // ResearchKit Framework
    let textChoices : [ORKTextChoice] = [ORKTextChoice(text: "Yes", value: "Yes"), ORKTextChoice(text: "No", value: "No")]
    let answerFormat = ORKTextChoiceAnswerFormat(style: ORKChoiceAnswerStyle.SingleChoice, textChoices: textChoices)
    let questionStepTitle1 = NSLocalizedString("Are you over 18 years of age?", comment: "")
    let questionStepTitle2 = NSLocalizedString("Can you read and understand English in order to provide informed consent and follow the industructions?", comment: "")
    
    let formItem01 = ORKFormItem(identifier: "question1", text: questionStepTitle1, answerFormat: answerFormat)
    formItem01.optional = false
    let formItem02 = ORKFormItem(identifier: "question2", text: questionStepTitle2, answerFormat: answerFormat)
    formItem02.optional = false
    
    let eligibilityStep = ORKFormStep(identifier: "EligibilityStepSurvey")
    eligibilityStep.title = "Eligibility"
    eligibilityStep.optional = false
    eligibilityStep.formItems = [
        formItem01,
        formItem02
    ]
    
    // Intro step
    let correctStep = ORKInstructionStep(identifier: "EligibilityStepCorrect")
    correctStep.title = NSLocalizedString("You are eligible to join the study.", comment: "")
    correctStep.detailText = NSLocalizedString("Tab the button below to begin the consent process", comment: "")

    
    let wrongStep = ORKInstructionStep(identifier: "EligibilityStepWrong")
    wrongStep.title = NSLocalizedString("You are not eligible to join the study..", comment: "")
    
    let welcomeStep = ORKVisualConsentStep(identifier: "EligibilityStepWelcome", document: consentDocument)
    welcomeStep.title = NSLocalizedString("Welcome", comment: "")
    welcomeStep.text = NSLocalizedString("The simple walkthrough will help you to understand the study, the impact it will have on your life, and will allow you to provide consent to participate.", comment: "")
    
    let activitiesStep1 = ORKInstructionStep(identifier: "EligibilityStepActivities1")
    activitiesStep1.title = "Activities"
    activitiesStep1.detailText = "This study will ask you to perform tasks and respond to surveys"
    
    let sharingStep = ORKConsentSharingStep(identifier: "EligibilityStepSharing")
    sharingStep.title = "Sharing Options"
    sharingStep.optional = false
    sharingStep.text = "The AlzPrevent team will recieve your study data from your participation in this study"
    
    let sharingChoices : [ORKTextChoice] = [ORKTextChoice(text: "Share my data with The AlzPrevent team and qualified researchers world wide.", value: "Yes"), ORKTextChoice(text: "Only share my data with The AlzPrevent team.", value: "No")]
    let sharingAnswerFormat = ORKTextChoiceAnswerFormat(style: ORKChoiceAnswerStyle.SingleChoice, textChoices: sharingChoices)
    
    sharingStep.answerFormat = sharingAnswerFormat
    
    let eligibilityTask = ORKNavigableOrderedTask(identifier: "EliginilityTask", steps: [eligibilityStep, wrongStep, correctStep])
    
    // Build navigation rules.
    var resultSelector = ORKResultSelector(stepIdentifier: "EligibilityStepSurvey", resultIdentifier: "question1")
    let predicateFormItem01 = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "Yes")
//
    resultSelector = ORKResultSelector(stepIdentifier: "EligibilityStepSurvey", resultIdentifier: "question2")
    let predicateFormItem02 = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "Yes")
//
    let predicateEligible = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateFormItem01, predicateFormItem02])
    let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [predicateEligible], destinationStepIdentifiers: ["EligibilityStepCorrect"], defaultStepIdentifier: "EligibilityStepWrong", validateArrays: true)
//
    eligibilityTask.setNavigationRule(predicateRule, forTriggerStepIdentifier: "EligibilityStepSurvey")
    
    // Add end direct rules to skip unneeded steps
    let directRule = ORKDirectStepNavigationRule(destinationStepIdentifier: "EligibilityStepSurvey")
    eligibilityTask.setNavigationRule(directRule, forTriggerStepIdentifier: "EligibilityStepWrong")

    let taskViewController = ORKTaskViewController(task: eligibilityTask, taskRunUUID: nil)
    taskViewController.delegate = self
    
    presentViewController(taskViewController, animated: true, completion: nil);
  }

  // MARK: Scroll View Delegate

  func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentPage = Int(collectionView.contentOffset.x / self.collectionView.frame.size.width)
    pageControl.currentPage = currentPage
  }

  // MARK: Collection View Delegate

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return collectionView.bounds.size
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4;
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(indexPath.item), forIndexPath: indexPath)
     return cell;
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Consent Document Creation Convenience
    
    /**
    A consent document provides the content for the visual consent and consent
    review steps. This helper sets up a consent document with some dummy
    content. You should populate your consent document to suit your study.
    */
    private var consentDocument: ORKConsentDocument {
        let consentDocument = ORKConsentDocument()
        
        /*
        This is the title of the document, displayed both for review and in
        the generated PDF.
        */
        consentDocument.title = NSLocalizedString("Learn More", comment: "")
        
        // This is the title of the signature page in the generated document.
        consentDocument.signaturePageTitle = NSLocalizedString("Consent", comment: "")
        
        /*
        This is the line shown on the signature page of the generated document,
        just above the signatures.
        */
        consentDocument.signaturePageContent = NSLocalizedString("I agree to participate in this research study.", comment: "")
        
        /*
        Add the participant signature, which will be filled in during the
        consent review process. This signature initially does not have a
        signature image or a participant name; these are collected during
        the consent review step.
        */
        let participantSignatureTitle = NSLocalizedString("Participant", comment: "")
        let participantSignature = ORKConsentSignature(forPersonWithTitle: participantSignatureTitle, dateFormatString: nil, identifier: String(Identifier.ConsentDocumentParticipantSignature))
        
        consentDocument.addSignature(participantSignature)
        
        /*
        Add the investigator signature. This is pre-populated with the
        investigator's signature image and name, and the date of their
        signature. If you need to specify the date as now, you could generate
        a date string with code here.
        
        This signature is only used for the generated PDF.
        */
        let signatureImage = UIImage(named: "signature")!
        let investigatorSignatureTitle = NSLocalizedString("Investigator", comment: "")
        let investigatorSignatureGivenName = NSLocalizedString("Jonny", comment: "")
        let investigatorSignatureFamilyName = NSLocalizedString("Appleseed", comment: "")
        let investigatorSignatureDateString = "3/10/15"
        
        let investigatorSignature = ORKConsentSignature(forPersonWithTitle: investigatorSignatureTitle, dateFormatString: nil, identifier: String(Identifier.ConsentDocumentInvestigatorSignature), givenName: investigatorSignatureGivenName, familyName: investigatorSignatureFamilyName, signatureImage: signatureImage, dateString: investigatorSignatureDateString)
        
        consentDocument.addSignature(investigatorSignature)
        
        /*
        This is the HTML content for the "Learn More" page for each consent
        section. In a real consent, this would be your content, and you would
        have different content for each section.
        
        If your content is just text, you can use the `content` property
        instead of the `htmlContent` property of `ORKConsentSection`.
        */
        let htmlContentString = "<p>\(loremIpsumLongText)</p>"
        
        /*
        These are all the consent section types that have pre-defined animations
        and images. We use them in this specific order, so we see the available
        animated transitions.
        */
        let consentSectionTypes: [ORKConsentSectionType] = [
            .Overview
//            .DataGathering,
//            .Privacy,
//            .DataUse,
//            .TimeCommitment,
//            .StudySurvey,
//            .StudyTasks,
//            .Withdrawing
        ]
        
        /*
        For each consent section type in `consentSectionTypes`, create an
        `ORKConsentSection` that represents it.
        
        In a real app, you would set specific content for each section.
        */
        var consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
            let consentSection = ORKConsentSection(type: contentSectionType)
            consentSection.title = "Welcome"
            consentSection.summary = loremIpsumShortText
            consentSection.customLearnMoreButtonTitle = "Learn more about this study first"
            consentSection.formalTitle = "Learn More"

            
            if contentSectionType == .Overview {
                consentSection.htmlContent = htmlContentString
            }
            else {
                consentSection.content = loremIpsumLongText
            }
            
            return consentSection
        }
        
        /*
        This is an example of a section that is only in the review document
        or only in the generated PDF, and is not displayed in `ORKVisualConsentStep`.
        */
        let consentSection = ORKConsentSection(type: .OnlyInDocument)
        consentSection.summary = NSLocalizedString(".OnlyInDocument Scene Summary", comment: "")
        consentSection.title = NSLocalizedString(".OnlyInDocument Scene", comment: "")
        consentSection.content = loremIpsumLongText
        
        consentSections += [consentSection]
        
        // Set the sections on the document after they've been created.
        consentDocument.sections = consentSections
        
        return consentDocument
    }
    
    // MARK: `ORKTask` Reused Text Convenience
    
    private var exampleDescription: String {
        return NSLocalizedString("Your description goes here.", comment: "")
    }
    
    private var exampleSpeechInstruction: String {
        return NSLocalizedString("Your more specific voice instruction goes here. For example, say 'Aaaah'.", comment: "")
    }
    
    private var exampleQuestionText: String {
        return NSLocalizedString("Your question goes here.", comment: "")
    }
    
    private var exampleHighValueText: String {
        return NSLocalizedString("High Value", comment: "")
    }
    
    private var exampleLowValueText: String {
        return NSLocalizedString("Low Value", comment: "")
    }
    
    private var exampleDetailText: String {
        return NSLocalizedString("Additional text can go here.", comment: "")
    }
    
    private var exampleEmailText: String {
        return NSLocalizedString("jappleseed@example.com", comment: "")
    }
    
    private var loremIpsumText: String {
        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    }
    
    private var loremIpsumShortText: String {
        return "The simple walkthrough will help you to understand the study, the impact it will have on your life, and will allow you to provide consent to participate."
    }
    
    private var loremIpsumMediumText: String {
        return "The following pages explain important information about the AlzPrevent app, and how the app is part of a research study."
    }
    
    private var loremIpsumLongText: String {
        return "About this consent form" + "<br/>" +
        "The following pages explain important information about the AlzPrevent app, and how the app is part of a research study." + "<br/>" +
        "Please read this form carefully." + "<br/>" +
        "Taking part in this research study is voluntary and is up to you. If you decide to take part in this research study, you must sign this form to show that you want to take part. We will give you a signed copy of this form to keep. If you have any questions about the research or about this form, please ask us." + "<br/>" +
        "People who agree to take part in research studies are called subjects”. This term will be used throughout this consent form. Partners HealthCare System is made up of Partners institutions (including Hong Kong University, where this study originates), health care providers, and researchers. In the rest of this consent form, we refer to the Partners system simply as “Partners”." + "<br/>" +
        "This study is sponsored by Hong Kong University." + "<br/>" +
        "Why is this research study being done?" + "<br/>" +
        "Alzheimer’s disease is one of the most devastating diseases, affecting 35 million people worldwide. It is a chronic neurodegenerative disease." + "<br/>" +
        
        "Today’s mobile phones (especially smartphones) are becoming powerful platforms for communicating, computing and sensing. We are investigating ways to help people make use of the capabilities of their smartphones to improve their health." + "<br/>" +
        
        "This study will make available to the public a free app (AlzPrevent) that users can install on their smartphones. The app will provide a variety of services to help users track their daily behaviors." + "<br/>" +
        "By analyzing this coded data across all app users, researchers can better understand the relationships between the variables and eventually prevent Alzheimer’s disease." + "<br/>" +
        
        "The goals of this research study are:" + "<br/>" +
        "Monitor and diagnose cognitive decline (blood analytics, psychological behavioral tests, GPS, accelerometer, gyroscope)" + "<br/>" +
        "Early diagnose mild cognitive impairment" + "<br/>" +
        "Prevent Alzheimer’s disease" + "<br/>" +
        
        "How long will I take part in this research study?" + "<br/>" +
        "If you choose to participate, this study lasts for one year. You are free to continue using the app for the personal insights if you wish." + "<br/>" +
        "Entering information and responding to surveys should take on average 10-20 minutes each day. Occasionally, tasks may take a little longer." + "<br/>" +
        "What will happen in this research study?" + "<br/>" +
        "This study will ask you to perform tasks and respond to surveys." + "<br/>" +
        "When users first launch the app, they will be asked to review a series of phone screens that describe the study and the relevant risks and benefits (“informed consent” process) so they can decide whether or not they wish to participate in the research study (participation in the research study is required in order to use the app); if they wish to participate, users will certify their agreement with the informed consent by entering their name and an email address (the email address is only used to enable users to receive a copy of the completed informed consent document – this document – in their email. Name and email will not be associated with any app data)." + "<br/>" +
        "AlzPrevent will ask you to:" + "<br/>" +
        "Answer survey questions about your health and health behaviors" + "<br/>" +
        "Perform cognitive and emotional tests provided everyday" + "<br/>" +
        "The app sends occasional reminders to complete study activities." + "<br/>" +
        "AlzPrevent uses the iPhone’s built-in accelerometer to passively keep track of physical activity (“passive” because this happens automatically and you do not need to enter any information). The app interprets accelerometer data as steps taken, or as different intensity levels of activity." + "<br/>" +
        "For these activity measures to be accurate, you should carry the iPhone on your person as much as possible (e.g., in your pocket, or clipped to your waist). For instance, if the iPhone is resting on a table when you go for a walk, it will not be able to detect this activity." + "<br/>" +
        
        "Occasionally, there will also be longer surveys that evaluate aspects such as your quality of life, or your sleep duration and quality." + "<br/>" +
        
        "AlzPrevent provides personalized feedback in the form of graphs and text on the smartphone to display your progress, and provide insights into your health behaviors. The app summarizes data about how cognitive or emotional patterns are associated with your glucose values. These insights may help you understand your health behaviors better, and help you monitor your cognitive function. Viewing the graphs and text is optional but may be useful or interesting to you." + "<br/>" +
        "In your Profile within AlzPrevent, you can set reminders for yourself to complete app activities. In general, more data entered in the app results in more accurate and informative insights." + "<br/>" +
        "What are the risks and possible discomforts from being in this research study?" + "<br/>" +
        "There are possible risks, discomforts and inconveniences associated with any research study. This study does not involve testing any new drugs or therapies, so we do not expect any medical side effects from participating." + "<br/>" +
        "The app is not designed to give medical advice, nor make suggestions related to Alzheimer’s disease treatment or medications." + "<br/>" +
        "Any information you provide is completely up to you. You can decline to answer survey questions or participate in the app’s tasks. If a survey question makes you feel uncomfortable, you are free to leave questions blank." + "<br/>" +
        "As with any smartphone app, use your common sense and follow prevailing laws about when and where you use your iPhone. Just as you would not text while driving, do not interact with the app while driving or doing any other activities which could result in injury. You can always wait until you are in a safe place to perform any app-related tasks." + "<br/>" +
        "Please see the sections on “Protecting Your Privacy” to learn more. Study participation may involve risks that are not known at this time." + "<br/>" +
        "What are the possible benefits from being in this research study?" + "<br/>" +
        "AlzPrevent analyzes your data to provide personalized insights and feedback to help you understand how your health behaviors (e.g., cognitive and emotional functions) can influence your glucose values. This may help you understand your cognitive functional status." + "<br/>" +
        "More generally, patients with Alzheimer’s disease may ultimately benefit from this research, because AlzPrevent and its research study will create an unprecedented crowd-sourced database of health behaviors and glucose values from people like you. Studying all this real-world data will help researchers better understand the relationships between cognitive/emotional function, diet, exercise, and glucose control in real-world people. (Traditionally, these studies are done by asking people to fill out very long questionnaires on paper every few years.) It will also help explore how the iPhone or smartphones can enable new kinds of clinical research." + "<br/>" +
        "By combining a personal app and a research study, AlzPrevent will help explore how the iPhone can enable new kinds of clinical research." + "<br/>" +
        "This study may also help researchers better understand what strategies in smartphone apps are well received among users, encourage more durable use of the app, and are most effective in reinforcing healthy behaviors." + "<br/>" +
        "Can I still get medical care with Partners if I don’t take part in this research study, or if I stop taking part?" + "<br/>" +
        "Yes. Regardless of where you get your medical care, your decision to participate or not will not change the medical care you get at a Partners hospital or anywhere else. Taking part in this research study is up to you." + "<br/>" +
        "What should I do if I want to stop taking part in the study?" + "<br/>" +
        "If you start the research study but later wish to drop out, simply use the “Leave Study” link in the Profile (this action cannot be undone), or contact the study investigators through the app. You may choose to leave the study at any time. Your decision will not result in any penalty or affect your medical care through your usual physicians or providers. Afterwards, you are free to delete the app from your smartphone." + "<br/>" +
        "The study investigators may also withdraw you from the study without your consent at any time for any reason, including if the study is cancelled." + "<br/>" +
        "Will I be paid to take part in this research study?" + "<br/>" +
        "There is no compensation or payment for taking part in this study." + "<br/>" +
        "What will I have to pay for if I take part in this research study?" + "<br/>" +
        "Participation in this study does not require you to change anything related to your iPhone account or data plan. The app can use either an existing mobile data plan or WiFi connections; you may configure the app to use only WiFi connections if you wish to limit impact on your data usage." + "<br/>" +
        "What happens if I am injured as a result of taking part in this research study?" + "<br/>" +
        "This study does not provide any health or medical care to participants, or compensation. Because this is a nationwide study that does not provide any health care to users, in the unlikely event that you are injured as a direct result of your participation in this study, users are advised to first seek medical treatment locally. The study investigators can also be contacted through the app or through the information below to assist in obtaining appropriate medical treatment. Your medical insurance, managed care plan, other benefits program, or other third parties, if appropriate, will be billed for this treatment. You will be responsible for any associated co-payments or deductibles as required by your insurance. If costs of care related to such an injury are not covered by your medical insurance or benefits program, you may be responsible for these costs. The study sponsors will not pay charges that your insurance does not cover. Neither the offer to provide medical assistance or any actual provision of medical services shall be construed as an admission of negligence or acceptance of liability." + "<br/>" +
        "Unanticipated injuries sometime occur in research even when no one is at fault. There are no plans to pay you or give you other compensation for an injury, should one occur. However, you are not giving up any of your legal rights by signing this form." + "<br/>" +
        "If you think you have been injured or have experienced a medical problem as a result of taking part in this study, contact study investigators through the app or through the information below as soon as possible." + "<br/>" +
        "If I have questions or concerns about this research study, whom can I call?" + "<br/>" +
        "If you have any questions about the study, your participation in the study, or concerns or complaints about the research, a member of our research team is available to communicate with you. You can contact the study investigator team through the app, or at the following email:" + "<br/>" +
        "Email:help@researchline.net" + "<br/>" +
        "You can also contact the principal investigator as below:" + "<br/>" +
        "Dr. Janet Hsiao" + "<br/>" +
        "Hong Kong University" + "<br/>" +
        "Phone: +852 3917 4874" + "<br/>" +
        "If I take part in this research study, how will you protect my privacy?" + "<br/>" +
        "We are committed to protecting your privacy. We take several steps to protect your privacy and the privacy of your app data." + "<br/>" +
        "For security, AlzPrevent requires that your iPhone be protected either by a passcode or the Apple Touch ID fingerprint sensor. This ensures that only you can enter and use the app." + "<br/>" +
        "To certify that you consent to participate in the study, the app asks you to enter your name and an email address. This allows study investigators to have a record of who participates in the study, and to email a copy of the signed consent form to you." + "<br/>" +
        "Your name and email are only used for the consent process, and are not associated with data collected from the app. Your identity (name, email) will be separated from your app data and kept as confidential as possible. Your app data will be associated only with a randomized study code that bears no relation to any identifiable information. This random code is stored completely separately from any personally identifying information. Only select individuals that are part of the research study will know the identities of people who participate in the study. These steps ensure that researchers analyzing the coded study data will not be able to connect it to any individual user." + "<br/>" +
        "Whenever app data is transferred to a research study computer, it will be encrypted so that others cannot interpret the data or associate it back to you." + "<br/>" +
        "Encrypted app data (stripped of personal identifiers, and associated only with a random code) will be sent to secure data servers used for the AlzPrevent research study. AlzPrevent uses Amazon Web Services (AWS) Cloud enhanced computational capacity to securely store AlzPrevent data. AWS poses no additional security concerns over existing traditional local computer cluster environments. All communications are encrypted when transmitting data or commands to and from the AWS. (Further information about data security within AWS can be found at https://aws.amazon.com/security/#features)" + "<br/>" +
        "Study investigators will analyze coded app data from everyone who agrees to participate in the AlzPrevent study, but they will be unable to connect it back to any individual user." + "<br/>" +
        "The results of this research may be published in a scientific or medical research journal, or presented at a medical research conference, so that others can learn from this study. Results will never be publicly presented in a way that would allow data to be associated with individual users." + "<br/>" +
        "After this study is completed, other researchers who are not part of the original study may request access to the coded study data (already stripped of personal identifiers such as your name or email), so that it can be analyzed in a new way to benefit medical research, or help guide development of future apps. Those requesting data must agree to use the data for research purposes responsibly and ethically, and in accordance with applicable regulations. Qualified researchers must agree to not attempt to re-identify any individuals. Criteria for qualified researchers will be set by the AlzPrevent investigators. Such criteria may include, but are not restricted to, being associated with an accredited research institution or not-for profit research institution, or submitting proof of IRB approval for their intended data use. Data sharing requests will be reviewed by a group of AlzPrevent study investigators." + "<br/>" +
        "<br/>" +
        "During the consent process, you will have the option to choose whether you agree to:" + "<br/>" +
        "(i) share your coded study data with qualified researchers (as described in the above paragraph), or" + "<br/>" +
        "(ii) share your coded study data only with the AlzPrevent team and its research partners; if you choose this option, your coded study data will be accessible only to the AlzPrevent team and its research partners, and will not be made available to other outside researchers." + "<br/>" +
        "Your choice will not affect your ability to participate in the AlzPrevent study." + "<br/>" +
        "Study data will never be sold to any third party." + "<br/>" +
        "If required by law, your data (study data and account information), and the signed consent form may be disclosed to:" + "<br/>" +
        "The US National Institute of Health, Department of Health and Human Services agencies, Office for Human Research Protection, and other agencies as required," + "<br/>" +
        "the Institutional Review Board at Hong Kong University that monitors the safety, and conduct of human research," + "<br/>" +
        "Others, if the law requires" + "<br/>" +
        "Informed Consent and Authorization" + "<br/>" +
        "Statement of Person Giving Informed Consent and Authorization" + "<br/>" +
        "I have read about this research study and this consent form, including potential risks and benefits (if any)." + "<br/>" +
        "I have had the opportunity to ask questions about the study and my part in it" + "<br/>" +
        "I understand the information presented to me"
    }
}

extension WelcomeViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch reason {
        case .Completed:
            dismissViewControllerAnimated(true, completion: {() in
                let storyboard = UIStoryboard(name: "Consent", bundle: nil)
                let controller = storyboard.instantiateInitialViewController()!
                self.navigationController?.pushViewController(controller, animated: true)
            })
            
        case .Discarded, .Failed, .Saved:
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, viewControllerForStep step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataStep {
            let healthStepViewController = HealthDataStepViewController(step: step)
            return healthStepViewController
        }
        
        return nil
    }
}