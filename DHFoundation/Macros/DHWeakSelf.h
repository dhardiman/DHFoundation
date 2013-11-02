//
//  DHWeakSelf.h
//  DHFoundation
//
//  Created by David Hardiman on 16/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#ifndef DHFoundation_DHWeakSelf_h
#define DHFoundation_DHWeakSelf_h

#define DHWeakSelf __weak __typeof(self) weakSelf = self
#define DHStrongSelf __strong __typeof(self) strongSelf = weakSelf

#endif
