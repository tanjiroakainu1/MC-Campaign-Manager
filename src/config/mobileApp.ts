/** Android APK served from Vite public/ for non-user home page download */

export const MOBILE_APP = {
  apkUrl: '/downloads/campaign-manager.apk',
  fileName: 'CampaignManager.apk',
  label: 'Campaign Manager',
  version: '1.0.0',
  packageId: 'com.siolence1.campaignmanager',
  apiUrl: 'https://mc-campaign-manager.vercel.app/api',
  sizeHint: '~50 MB',
} as const;
