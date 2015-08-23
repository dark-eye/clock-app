/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef CUSTOMALARMSOUND_H
#define CUSTOMALARMSOUND_H

#include <QObject>

class CustomAlarmSound: public QObject
{
    Q_OBJECT

    // READONLY Property to return the custom alarm sound directory path
    Q_PROPERTY( QString alarmSoundDirectory
                READ alarmSoundDirectory
                CONSTANT)

public:
    CustomAlarmSound(QObject *parent = 0);

    // Function to return the custom alarm sound directory path
    QString alarmSoundDirectory() const;

public slots:
    // Function to delete a custom alarm sound
    void deleteAlarmSound(const QString &soundName);

    // Function to delete old alarm file sound according to file name from full path.
    // It will able to replace sound alarm with new version
    void prepareToAddAlarmSound(const QString &soundPath);

    // Function to create the CustomSounds alarm directory
    void createAlarmSoundDirectory();

private:
    QString m_customAlarmDir;
};

#endif
