/*
 * Copyright © 2012 Canonical Ltd.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Thomas Voss <thomas.voss@canonical.com>
 */

#include "mir/input/grab_filter.h"

#include "mir/application.h"
#include "mir/application_manager.h"
#include "mir/input/dispatcher.h"

#include <cassert>
#include <memory>

namespace mi = mir::input;

void mi::GrabFilter::accept(Event* e)
{
    assert(e);
    ChainingFilter::accept(e);
}

mi::GrabHandle mi::GrabFilter::push_grab(std::shared_ptr<EventHandler> const& )
{
	return mi::GrabHandle();
}

void mi::GrabFilter::release_grab(GrabHandle const& )
{
}
