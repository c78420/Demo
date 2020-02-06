//
//  Tutors.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/9.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import SwiftUI

struct Tutors: View {
    var tutors: [Tutor] = []
    
    var body: some View {
        List(tutors) { tutor in
            TutorCell(tutor: tutor)
        }
    }
}

struct TutorCell: View {
    let tutor: Tutor
    
    var body: some View {
        NavigationLink(
        destination: TutorDetail(name: tutor.name, headline: tutor.headline, bio: tutor.bio)) {
            Image(tutor.imageName)
                .cornerRadius(40)
            VStack(alignment: .leading) {
                Text(tutor.name)
                Text(tutor.headline)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct Tutors_Previews: PreviewProvider {
    static var previews: some View {
        Tutors(tutors: testData)
    }
}
