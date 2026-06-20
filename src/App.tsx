import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import Layout from './components/Layout';
import ProtectedRoute from './components/ProtectedRoute';
import Login from './pages/Login';
import Register from './pages/Register';
import Home from './pages/Home';

import SuperAdminDashboard from './roles/super-admin/SuperAdminDashboard';
import UserManagement from './roles/super-admin/UserManagement';
import SystemSettings from './roles/super-admin/SystemSettings';
import CampaignCategories from './roles/super-admin/CampaignCategories';
import AllCampaigns from './roles/super-admin/AllCampaigns';
import SystemReports from './roles/super-admin/SystemReports';

import MarketingManagerDashboard from './roles/marketing-manager/MarketingManagerDashboard';
import CreateCampaign from './roles/marketing-manager/CreateCampaign';
import ApproveCampaigns from './roles/marketing-manager/ApproveCampaigns';
import BudgetManagement from './roles/marketing-manager/BudgetManagement';
import TaskAssignment from './roles/marketing-manager/TaskAssignment';
import PerformanceMonitor from './roles/marketing-manager/PerformanceMonitor';
import MarketingStrategies from './roles/marketing-manager/MarketingStrategies';
import CampaignReports from './roles/marketing-manager/CampaignReports';

import ContentCreatorDashboard from './roles/content-creator/ContentCreatorDashboard';
import CreateContent from './roles/content-creator/CreateContent';
import MediaUpload from './roles/content-creator/MediaUpload';
import DesignMaterials from './roles/content-creator/DesignMaterials';
import ContentSchedule from './roles/content-creator/ContentSchedule';
import UpdateContent from './roles/content-creator/UpdateContent';
import SubmitApproval from './roles/content-creator/SubmitApproval';
import AssignedCampaigns from './roles/content-creator/AssignedCampaigns';

import MarketingAnalystDashboard from './roles/marketing-analyst/MarketingAnalystDashboard';
import CampaignMetrics from './roles/marketing-analyst/CampaignMetrics';
import PerformanceAnalysis from './roles/marketing-analyst/PerformanceAnalysis';
import AudienceEngagement from './roles/marketing-analyst/AudienceEngagement';
import ROITracking from './roles/marketing-analyst/ROITracking';
import AnalyticsReports from './roles/marketing-analyst/AnalyticsReports';
import DataExport from './roles/marketing-analyst/DataExport';
import PerformanceDashboard from './roles/marketing-analyst/PerformanceDashboard';

function RootRedirect() {
  const { isAuthenticated, getDashboardPath } = useAuth();
  if (isAuthenticated) return <Navigate to={getDashboardPath()} replace />;
  return <Home />;
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<RootRedirect />} />
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />

      <Route element={<Layout />}>
        {/* Super Admin */}
        <Route path="/super-admin" element={<ProtectedRoute allowedRoles={['super-admin']}><SuperAdminDashboard /></ProtectedRoute>} />
        <Route path="/super-admin/users" element={<ProtectedRoute allowedRoles={['super-admin']}><UserManagement /></ProtectedRoute>} />
        <Route path="/super-admin/settings" element={<ProtectedRoute allowedRoles={['super-admin']}><SystemSettings /></ProtectedRoute>} />
        <Route path="/super-admin/categories" element={<ProtectedRoute allowedRoles={['super-admin']}><CampaignCategories /></ProtectedRoute>} />
        <Route path="/super-admin/campaigns" element={<ProtectedRoute allowedRoles={['super-admin']}><AllCampaigns /></ProtectedRoute>} />
        <Route path="/super-admin/reports" element={<ProtectedRoute allowedRoles={['super-admin']}><SystemReports /></ProtectedRoute>} />

        {/* Marketing Manager */}
        <Route path="/marketing-manager" element={<ProtectedRoute allowedRoles={['marketing-manager']}><MarketingManagerDashboard /></ProtectedRoute>} />
        <Route path="/marketing-manager/create" element={<ProtectedRoute allowedRoles={['marketing-manager']}><CreateCampaign /></ProtectedRoute>} />
        <Route path="/marketing-manager/approve" element={<ProtectedRoute allowedRoles={['marketing-manager']}><ApproveCampaigns /></ProtectedRoute>} />
        <Route path="/marketing-manager/budget" element={<ProtectedRoute allowedRoles={['marketing-manager']}><BudgetManagement /></ProtectedRoute>} />
        <Route path="/marketing-manager/tasks" element={<ProtectedRoute allowedRoles={['marketing-manager']}><TaskAssignment /></ProtectedRoute>} />
        <Route path="/marketing-manager/monitor" element={<ProtectedRoute allowedRoles={['marketing-manager']}><PerformanceMonitor /></ProtectedRoute>} />
        <Route path="/marketing-manager/strategies" element={<ProtectedRoute allowedRoles={['marketing-manager']}><MarketingStrategies /></ProtectedRoute>} />
        <Route path="/marketing-manager/reports" element={<ProtectedRoute allowedRoles={['marketing-manager']}><CampaignReports /></ProtectedRoute>} />

        {/* Content Creator */}
        <Route path="/content-creator" element={<ProtectedRoute allowedRoles={['content-creator']}><ContentCreatorDashboard /></ProtectedRoute>} />
        <Route path="/content-creator/create" element={<ProtectedRoute allowedRoles={['content-creator']}><CreateContent /></ProtectedRoute>} />
        <Route path="/content-creator/upload" element={<ProtectedRoute allowedRoles={['content-creator']}><MediaUpload /></ProtectedRoute>} />
        <Route path="/content-creator/design" element={<ProtectedRoute allowedRoles={['content-creator']}><DesignMaterials /></ProtectedRoute>} />
        <Route path="/content-creator/schedule" element={<ProtectedRoute allowedRoles={['content-creator']}><ContentSchedule /></ProtectedRoute>} />
        <Route path="/content-creator/update" element={<ProtectedRoute allowedRoles={['content-creator']}><UpdateContent /></ProtectedRoute>} />
        <Route path="/content-creator/submit" element={<ProtectedRoute allowedRoles={['content-creator']}><SubmitApproval /></ProtectedRoute>} />
        <Route path="/content-creator/assigned" element={<ProtectedRoute allowedRoles={['content-creator']}><AssignedCampaigns /></ProtectedRoute>} />

        {/* Marketing Analyst */}
        <Route path="/marketing-analyst" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><MarketingAnalystDashboard /></ProtectedRoute>} />
        <Route path="/marketing-analyst/metrics" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><CampaignMetrics /></ProtectedRoute>} />
        <Route path="/marketing-analyst/analysis" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><PerformanceAnalysis /></ProtectedRoute>} />
        <Route path="/marketing-analyst/engagement" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><AudienceEngagement /></ProtectedRoute>} />
        <Route path="/marketing-analyst/roi" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><ROITracking /></ProtectedRoute>} />
        <Route path="/marketing-analyst/reports" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><AnalyticsReports /></ProtectedRoute>} />
        <Route path="/marketing-analyst/export" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><DataExport /></ProtectedRoute>} />
        <Route path="/marketing-analyst/dashboard" element={<ProtectedRoute allowedRoles={['marketing-analyst']}><PerformanceDashboard /></ProtectedRoute>} />
      </Route>

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
