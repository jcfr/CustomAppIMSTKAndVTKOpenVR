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

#ifndef __qCustomAppIMSTKAppMainWindow_h
#define __qCustomAppIMSTKAppMainWindow_h

// CustomAppIMSTK includes
#include "qCustomAppIMSTKAppExport.h"
class qCustomAppIMSTKAppMainWindowPrivate;

// Slicer includes
#include "qSlicerMainWindow.h"

class Q_CUSTOMAPPIMSTKANDVTKOPENVR_APP_EXPORT qCustomAppIMSTKAppMainWindow : public qSlicerMainWindow
{
  Q_OBJECT
public:
  typedef qSlicerMainWindow Superclass;

  qCustomAppIMSTKAppMainWindow(QWidget *parent=0);
  virtual ~qCustomAppIMSTKAppMainWindow();

public slots:
  void on_HelpAboutCustomAppIMSTKAppAction_triggered();

protected:
  qCustomAppIMSTKAppMainWindow(qCustomAppIMSTKAppMainWindowPrivate* pimpl, QWidget* parent);

private:
  Q_DECLARE_PRIVATE(qCustomAppIMSTKAppMainWindow);
  Q_DISABLE_COPY(qCustomAppIMSTKAppMainWindow);
};

#endif
