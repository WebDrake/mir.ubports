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
 * Authored by: Kevin DuBois <kevin.dubois@canonical.com>
 */
#ifndef MIR_CLIENT_PRIVATE_MIR_CONNECTION_H_
#define MIR_CLIENT_PRIVATE_MIR_CONNECTION_H_

#include <string>
#include <memory>
#include <set>
#include <unordered_set>

#include "mir/thread/all.h"

#include "mir_protobuf.pb.h"

#include "mir_client/mir_client_library.h"

#include "mir_client/mir_rpc_channel.h"
#include "mir_client/private/mir_wait_handle.h"

namespace mir
{
namespace client
{
class Logger;

// TODO the connection should track all associated surfaces, and release them on
// disconnection.
class MirConnection
{
public:
    MirConnection(const std::string& socket_file,
                  std::shared_ptr<Logger> const & log);
    ~MirConnection();

    MirConnection(MirConnection const &) = delete;
    MirConnection& operator=(MirConnection const &) = delete;

    MirWaitHandle* create_surface(
        MirSurfaceParameters const & params,
        mir_surface_lifecycle_callback callback,
        void * context);

    char const * get_error_message();

    MirWaitHandle* connect(
        const char* app_name,
        mir_connected_callback callback,
        void * context);

    void disconnect();

    static bool is_valid(MirConnection *connection);
private:
    MirRpcChannel channel;
    protobuf::DisplayServer::Stub server;
    std::shared_ptr<Logger> log;
    protobuf::Void void_response;
    mir::protobuf::Connection connect_result;
    mir::protobuf::Void ignored;
    mir::protobuf::ConnectParameters connect_parameters;

    std::string error_message;
    std::set<MirSurface*> surfaces;

    MirWaitHandle connect_wait_handle;
    MirWaitHandle disconnect_wait_handle;

    void done_disconnect();
    void connected(mir_connected_callback callback, void * context);

    static std::mutex connection_guard;
    static std::unordered_set<MirConnection*> valid_connections;
};
}
}

#endif /* MIR_CLIENT_PRIVATE_MIR_CONNECTION_H_ */
