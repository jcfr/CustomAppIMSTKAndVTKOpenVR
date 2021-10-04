/*==============================================================================

  Copyright (c) Kitware, Inc.

  See http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  This file was originally developed by Julien Finet, Kitware, Inc.
  and was partially funded by NIH grant 3P41RR013218-12S1

==============================================================================*/

#ifndef __qCustomAppIMSTKAndVTKOpenVRAppMainWindow_h
#define __qCustomAppIMSTKAndVTKOpenVRAppMainWindow_h

// CustomAppIMSTKAndVTKOpenVR includes
#include "qCustomAppIMSTKAndVTKOpenVRAppExport.h"
class qCustomAppIMSTKAndVTKOpenVRAppMainWindowPrivate;

// Slicer includes
#include "qSlicerMainWindow.h"

class Q_CUSTOMAPPIMSTKANDVTKOPENVR_APP_EXPORT qCustomAppIMSTKAndVTKOpenVRAppMainWindow : public qSlicerMainWindow
{
  Q_OBJECT
public:
  typedef qSlicerMainWindow Superclass;

  qCustomAppIMSTKAndVTKOpenVRAppMainWindow(QWidget *parent=0);
  virtual ~qCustomAppIMSTKAndVTKOpenVRAppMainWindow();

public slots:
  void on_HelpAboutCustomAppIMSTKAndVTKOpenVRAppAction_triggered();

protected:
  qCustomAppIMSTKAndVTKOpenVRAppMainWindow(qCustomAppIMSTKAndVTKOpenVRAppMainWindowPrivate* pimpl, QWidget* parent);

private:
  Q_DECLARE_PRIVATE(qCustomAppIMSTKAndVTKOpenVRAppMainWindow);
  Q_DISABLE_COPY(qCustomAppIMSTKAndVTKOpenVRAppMainWindow);
};

#endif
