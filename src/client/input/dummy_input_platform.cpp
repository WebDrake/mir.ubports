/*
 * Copyright © 2013 Canonical Ltd.
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
 * Authored by: Robert Carr <robert.carr@canonical.com>
 */

#include "input_platform.h"
#include "input_receiver_thread.h"

namespace mcli = mir::client::input;

namespace mir
{
namespace client
{
namespace input
{

struct DummyInputThread : public InputReceiverThread
{
    void start() {}
    void stop() {}
    void join() {}
};

struct DummyInputPlatform : public InputPlatform
{
    std::shared_ptr<InputReceiverThread> create_input_thread(int /* fd */, std::function<void(MirEvent*)> const& /* callback */)
    {
        return std::make_shared<DummyInputThread>();
    }
};

}
}
} // namespace mir

std::shared_ptr<mcli::InputPlatform>
mcli::InputPlatform::create()
{
    return std::make_shared<DummyInputPlatform>();
}
