//
//  ContentView.swift
//  project.y
//
//  Created by Nadeem Rawashdeh on 09.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GoalsViewModel()
    @State private var showingAddGoal = false
    @State private var showingStats = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.spacing) {
                    // Stats Summary
                    HStack {
                        StatCard(
                            title: "Active Goals",
                            value: "\(viewModel.goals.count)",
                            icon: "target",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Completed",
                            value: "\(viewModel.completedMilestonesCount)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryFilterButton(title: "All", isSelected: viewModel.selectedCategory == nil) {
                                viewModel.selectedCategory = nil
                            }
                            
                            ForEach(GoalCategory.allCases, id: \.self) { category in
                                CategoryFilterButton(
                                    title: category.rawValue,
                                    icon: category.icon,
                                    color: category.color,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    
                    // Goals List
                    LazyVStack(spacing: AppTheme.spacing) {
                        ForEach(viewModel.filteredGoals) { goal in
                            GoalTimelineCard(goal: goal, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Year Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .imageScale(.large)
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingStats) {
                NavigationStack {
                    VStack(spacing: 20) {
                        // Overall Progress
                        VStack(spacing: 8) {
                            Text("Overall Progress")
                                .font(.headline)
                            Text("\(Int(viewModel.overallProgress * 100))%")
                                .font(.system(size: 48, weight: .bold))
                            ProgressView(value: viewModel.overallProgress)
                                .tint(AppTheme.primaryColor)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppTheme.backgroundColor)
                                .shadow(color: AppTheme.cardShadow, radius: 2)
                        )
                        
                        // Statistics Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatCard(
                                title: "Active Goals",
                                value: "\(viewModel.goals.count)",
                                icon: "target",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Completed Milestones",
                                value: "\(viewModel.completedMilestonesCount)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Total Milestones",
                                value: "\(viewModel.totalMilestonesCount)",
                                icon: "list.bullet",
                                color: .orange
                            )
                            
                            StatCard(
                                title: "Categories",
                                value: "\(Set(viewModel.goals.map(\.category)).count)",
                                icon: "folder.fill",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.top)
                    .navigationTitle("Statistics")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { showingStats = false }
                        }
                    }
                }
            }
        }
    }
}

// Supporting Views
struct CategoryFilterButton: View {
    let title: String
    var icon: String?
    var color: Color = AppTheme.primaryColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? color : AppTheme.secondaryBackground)
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
            
            Text(value)
                .font(.title)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppTheme.backgroundColor)
                .shadow(color: AppTheme.cardShadow, radius: 2)
        )
    }
}

#Preview {
    ContentView()
}
