-- Calculating step-by-step conversion rates for the onboarding funnel
WITH FunnelSteps AS (    SELECT         COUNT(DISTINCT CASE WHEN event_name = 'click_campaign_banner' THEN user_id END) as step1_landing,
        COUNT(DISTINCT CASE WHEN event_name = 'input_phone_otp' THEN user_id END) as step2_otp,
        COUNT(DISTINCT CASE WHEN event_name = 'ekyc_face_scan_success' THEN user_id END) as step3_ekyc,
        COUNT(DISTINCT CASE WHEN event_name = 'card_terms_accepted' THEN user_id END) as step4_submit,
        COUNT(DISTINCT CASE WHEN event_name = 'virtual_card_activated' THEN user_id END) as step5_activation
    FROM VIB_app_logs_2024
    WHERE campaign_id = 'AnhTraiSayHi_2024'
)
SELECT 
    step1_landing as "1. Landing Page",
    step2_otp as "2. OTP Verified",
    step3_ekyc as "3. eKYC Success",
    step4_submit as "4. Form Submitted",
    step5_activation as "5. Card Activated",
    ROUND(100.0 * step2_otp / step1_landing, 2) as drop_to_otp,
    ROUND(100.0 * step3_ekyc / step2_otp, 2) as drop_to_ekyc, -- Crucial metric
    ROUND(100.0 * step5_activation / step4_submit, 2) as drop_to_activate
FROM FunnelSteps;
