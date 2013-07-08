/*
 * Copyright © 2013 Canonical Ltd.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3,
 * as published by the Free Software Foundation.
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

#ifndef MIR_TEST_DOUBLES_MOCK_GRAPHICS_INFO_H_
#define MIR_TEST_DOUBLES_MOCK_GRAPHICS_INFO_H_

#include "mir/graphics/surface_info.h"
#include <gmock/gmock.h>

namespace mir
{
namespace test
{
namespace doubles
{

class MockGraphicsInfo : public graphics::SurfaceInfoController 
{
public:
    MockGraphicsInfo()
    {
        using namespace testing;
    /*
        ON_CALL(*this, size_and_position())
            .WillByDefault(
                Return(geometry::Rectangle{
                        geometry::Point{geometry::X{}, geometry::Y{}},
                        geometry::Size{geometry::Width{}, geometry::Height{}}}));
    */
    }
    ~MockGraphicsInfo() noexcept {}
   // MOCK_CONST_METHOD0(size_and_position, geometry::Rectangle());
    MOCK_CONST_METHOD0(alpha, float());
    MOCK_METHOD1(apply_alpha, void(float));
};

typedef ::testing::NiceMock<MockGraphicsInfo> StubGraphicsInfo;
}
}
}
#endif /* MIR_TEST_DOUBLES_MOCK_GRAPHICS_INFO_H_ */
