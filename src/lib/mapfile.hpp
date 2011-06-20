/***************************************************************************

    mapfile.hpp - Sidudict, a StarDict clone based on QStarDict
    this file was taken from qstardict-0.13.1 for Sidudict

 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the Free Software           *
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,            *
 *   MA 02110-1301, USA.                                                   *
 *                                                                         *
 ***************************************************************************/

#ifndef _MAPFILE_HPP_
#define _MAPFILE_HPP_

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#ifdef HAVE_MMAP
#  include <sys/types.h>
#  include <fcntl.h>
#  include <sys/mman.h>
#endif
#ifdef _WIN32
#  include <windows.h>
#endif
#include <glib.h>

class MapFile
{
    public:
        MapFile(void) :
                data(NULL),
#ifdef HAVE_MMAP
                mmap_fd( -1)
#elif defined(_WIN32)
                hFile(0),
                hFileMap(0)
#endif
        {
        }
        ~MapFile();
        bool open(const char *file_name, unsigned long file_size);
        inline gchar *begin(void)
        {
            return data;
        }
    private:
        char *data;
        unsigned long size;
#ifdef HAVE_MMAP

        int mmap_fd;
#elif defined(_WIN32)

        HANDLE hFile;
        HANDLE hFileMap;
#endif
};

inline bool MapFile::open(const char *file_name, unsigned long file_size)
{
    size = file_size;
#ifdef HAVE_MMAP

    if ((mmap_fd = ::open(file_name, O_RDONLY)) < 0)
    {
        //g_print("Open file %s failed!\n",fullfilename);
        return false;
    }
    data = (gchar *)mmap( NULL, file_size, PROT_READ, MAP_SHARED, mmap_fd, 0);
    if ((void *)data == (void *)( -1))
    {
        //g_print("mmap file %s failed!\n",idxfilename);
        data = NULL;
        return false;
    }
#elif defined( _WIN32)
#ifdef UNICODE
    gunichar2 *fn = g_utf8_to_utf16(file_name, -1, NULL, NULL, NULL);
#else // UNICODE
    gchar *fn = file_name;
#endif // UNICODE
    hFile = CreateFile(fn, GENERIC_READ, 0, NULL, OPEN_ALWAYS,
                       FILE_ATTRIBUTE_NORMAL, 0);
#ifdef UNICODE
    g_free(fn);
#endif // UNICODE
    hFileMap = CreateFileMapping(hFile, NULL, PAGE_READONLY, 0,
                                 file_size, NULL);
    data = (gchar *)MapViewOfFile(hFileMap, FILE_MAP_READ, 0, 0, file_size);
#else // defined( _WIN32)

    gsize read_len;
    if (!g_file_get_contents(file_name, &data, &read_len, NULL))
        return false;

    if (read_len != file_size)
        return false;
#endif

    return true;
}

inline MapFile::~MapFile()
{
    if (!data)
        return ;
#ifdef HAVE_MMAP

    munmap(data, size);
    close(mmap_fd);
#else
#  ifdef _WIN32

    UnmapViewOfFile(data);
    CloseHandle(hFileMap);
    CloseHandle(hFile);
#  else

    g_free(data);
#  endif
#endif
}

#endif//!_MAPFILE_HPP_
